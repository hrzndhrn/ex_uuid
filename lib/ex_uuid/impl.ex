defmodule ExUUID.Impl do
  @moduledoc false

  @compile {:inline, clock_sequence: 1, timestamp: 1, nibble_to_hex: 1}

  @interval_offset 122_192_928_000_000_000
  @intervals_per_microsecond 10

  @version1 <<1::4>>
  @version6 <<6::4>>
  @versions %{v3: 3, v4: 4, v5: 5}
  @all_versions [1, 3, 4, 5, 6]

  @variant <<2::2>>

  @dns <<0x6BA7B8109DAD11D180B400C04FD430C8::128>>
  @url <<0x6BA7B8119DAD11D180B400C04FD430C8::128>>
  @oid <<0x6BA7B8129DAD11D180B400C04FD430C8::128>>
  @x500 <<0x6BA7B8149DAD11D180B400C04FD430C8::128>>

  @formats [:default, :binary, :hex]

  def uuid(
        # version: 3, 4 and 5
        version,
        <<
          timestamp_hi::32,
          timestamp_mid::16,
          _::4,
          timestamp_low::12,
          _::2,
          clock_sequence_hi::6,
          clock_sequence_low::8,
          node_id::48
        >>,
        format
      )
      when format in @formats do
    format(
      <<
        timestamp_hi::32,
        timestamp_mid::16,
        Map.fetch!(@versions, version)::4,
        timestamp_low::12,
        @variant,
        clock_sequence_hi::6,
        clock_sequence_low::8,
        node_id::48
      >>,
      format
    )
  end

  def uuid(
        :v1,
        <<timestamp_hi::12, timestamp_mid::16, timestamp_low::32>>,
        <<clock_sequence_hi::6, clock_sequence_low::8>>,
        <<node_id::48>>,
        format
      )
      when format in @formats do
    format(
      <<
        timestamp_low::32,
        timestamp_mid::16,
        @version1,
        timestamp_hi::12,
        @variant,
        clock_sequence_hi::6,
        clock_sequence_low::8,
        node_id::48
      >>,
      format
    )
  end

  def uuid(
        :v6,
        <<timestamp_hi::12, timestamp_mid::16, timestamp_low_1::20, timestamp_low_2::12>>,
        <<clock_sequence_hi::6, clock_sequence_low::8>>,
        <<node_id::48>>,
        format
      )
      when format in @formats do
    format(
      <<
        timestamp_hi::12,
        timestamp_mid::16,
        timestamp_low_1::20,
        @version6,
        timestamp_low_2::12,
        @variant,
        clock_sequence_hi::6,
        clock_sequence_low::8,
        node_id::48
      >>,
      format
    )
  end

  def variant(<<1::1, 1::1, 1::1>>), do: :reserved_future
  def variant(<<1::1, 1::1, 0::1>>), do: :reserved_microsoft
  def variant(<<1::1, 0::1, _::1>>), do: :rfc4122
  def variant(<<0::1, _::1, _::1>>), do: :reserved_ncs

  def variant(<<_::64, variant::3, _::61>>), do: {:ok, variant(<<variant::3>>)}

  def variant(uuid) do
    with {:ok, binary} <- to_binary(uuid),
         {:ok, _version} <- version(binary),
         do: variant(binary)
  end

  def version(<<_::48, version::4, _::76>>) do
    case version in @all_versions do
      true -> {:ok, version}
      false -> :error
    end
  end

  def version(uuid) do
    with {:ok, binary} <- to_binary(uuid), do: version(binary)
  end

  def valid?(uuid), do: match?({:ok, _}, version(uuid))

  defp validate(<<_::128>> = uuid) do
    case valid?(uuid) do
      true -> {:ok, uuid}
      false -> :error
    end
  end

  def to_string(<<uuid::128>>, format) when format in @formats,
    do: {:ok, format(<<uuid::128>>, format)}

  def to_string(_, _), do: :error

  def to_binary(<<g0::64, ?-, g1::32, ?-, g2::32, ?-, g3::32, ?-, g4::96>>) do
    with {:ok, bin} <- hex_to_binary(<<g0::64, g1::32, g2::32, g3::32, g4::96>>) do
      validate(bin)
    end
  end

  def to_binary(<<uuid::binary-size(32)>>) do
    with {:ok, bin} <- hex_to_binary(uuid) do
      validate(bin)
    end
  end

  def to_binary(<<_::128>> = uuid), do: validate(uuid)

  def to_binary(_), do: :error

  defp format(<<g1::32, g2::16, g3::16, g4::16, g5::48>>, :default) do
    """
    #{binary_to_hex(<<g1::32>>)}\
    -#{binary_to_hex(<<g2::16>>)}\
    -#{binary_to_hex(<<g3::16>>)}\
    -#{binary_to_hex(<<g4::16>>)}\
    -#{binary_to_hex(<<g5::48>>)}\
    """
  end

  defp format(binary, :binary), do: binary

  defp format(binary, :hex), do: binary |> binary_to_hex() |> :erlang.list_to_binary()

  def hash(:v3, namespace, name) do
    with {:ok, data} <- namespace_data(namespace, name) do
      {:ok, :crypto.hash(:md5, data)}
    end
  end

  def hash(:v5, namespace, name) do
    with {:ok, data} <- namespace_data(namespace, name) do
      {:ok, trim_hash(:crypto.hash(:sha, data))}
    end
  end

  defp trim_hash(<<hash::128, _::bits>>), do: <<hash::128>>

  defp namespace_data(:dns, name), do: {:ok, <<@dns, name::binary>>}
  defp namespace_data(:url, name), do: {:ok, <<@url, name::binary>>}
  defp namespace_data(:oid, name), do: {:ok, <<@oid, name::binary>>}
  defp namespace_data(:x500, name), do: {:ok, <<@x500, name::binary>>}
  defp namespace_data(nil, name), do: {:ok, <<0::128, name::binary>>}

  defp namespace_data(uuid, name) when is_binary(uuid) do
    with {:ok, <<bin::128>>} <- to_binary(uuid) do
      {:ok, <<bin::128, name::binary>>}
    end
  end

  def clock_sequence, do: clock_sequence(:crypto.strong_rand_bytes(2))
  defp clock_sequence(<<clock_sequence::size(14), _::bits>>), do: <<clock_sequence::size(14)>>

  def timestamp, do: timestamp(:os.timestamp())

  defp timestamp({megasecond, second, microsecond}) do
    timestamp(megasecond * 1_000_000_000_000 + second * 1_000_000 + microsecond)
  end

  defp timestamp(microsecond) do
    <<microsecond * @intervals_per_microsecond + @interval_offset::60>>
  end

  def random_node_id(true), do: :crypto.strong_rand_bytes(6)
  def random_node_id(false), do: node_id()

  def node_id do
    with {:ok, ifaddrs} <- :inet.getifaddrs() do
      ifaddrs |> hwaddr() |> :erlang.list_to_binary()
    end
  end

  defp hwaddr(ifaddrs) do
    ifaddrs
    |> Enum.find_value(:random, fn {_key, value} ->
      case Keyword.get(value, :hwaddr) do
        nil -> false
        [0, 0, 0, 0, 0, 0] -> false
        [_, _, _, _, _, _] = hwaddr -> hwaddr
        _ -> false
      end
    end)
    |> case do
      :random -> :crypto.strong_rand_bytes(6)
      hwaddr -> hwaddr
    end
  end

  defp binary_to_hex(binary, acc \\ [])
  defp binary_to_hex(<<>>, acc), do: Enum.reverse(acc)

  defp binary_to_hex(<<x::4, y::4, rest::binary>>, acc),
    do: binary_to_hex(rest, [nibble_to_hex(y), nibble_to_hex(x) | acc])

  defp nibble_to_hex(nibble),
    do: elem({?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?a, ?b, ?c, ?d, ?e, ?f}, nibble)

  defp hex_to_binary(hex, acc \\ <<>>)
  defp hex_to_binary(<<>>, acc), do: {:ok, acc}

  defp hex_to_binary(<<x::binary-size(2), rest::binary>>, acc) do
    case Integer.parse(x, 16) do
      {int, ""} -> hex_to_binary(rest, <<acc::binary, int::integer-size(8)>>)
      _ -> :error
    end
  end
end
