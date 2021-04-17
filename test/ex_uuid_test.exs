defmodule ExUUIDTest do
  use ExUnit.Case

  @invalid_uuid "9073926b-f000-ffff-abc9-fad77ae3e8eb"

  describe "new/2" do
    test "creates version 1 uuid" do
      assert is_valid_uuid ExUUID.new(:v1)
      assert uuid_format ExUUID.new(:v1), :default
      assert is_valid_uuid ExUUID.new(:v1, format: :default)
      assert uuid_format ExUUID.new(:v1, format: :default), :default
    end

    test "creates version 1 uuid with format :hex" do
      assert is_valid_uuid ExUUID.new(:v1, format: :hex)
      assert uuid_format ExUUID.new(:v1, format: :hex), :hex
    end

    test "creates version 1 uuid with format :binary" do
      assert is_valid_uuid ExUUID.new(:v1, format: :binary)
      assert uuid_format ExUUID.new(:v1, format: :binary), :binary
    end

    test "creates version 4 uuid" do
      assert is_valid_uuid ExUUID.new(:v4)
      assert uuid_format ExUUID.new(:v4), :default
      assert is_valid_uuid ExUUID.new(:v4, format: :default)
      assert uuid_format ExUUID.new(:v4, format: :default), :default
    end

    test "creates version 4 uuid with format :hex" do
      assert is_valid_uuid ExUUID.new(:v4, format: :hex)
      assert uuid_format ExUUID.new(:v4, format: :hex), :hex
    end

    test "creates version 4 uuid with format :binary" do
      assert is_valid_uuid ExUUID.new(:v4, format: :binary)
      assert uuid_format ExUUID.new(:v4, format: :binary), :binary
    end

    test "creates version 6 uuid" do
      assert is_valid_uuid ExUUID.new(:v6)
      assert uuid_format ExUUID.new(:v6), :default
      assert is_valid_uuid ExUUID.new(:v6, format: :default)
      assert uuid_format ExUUID.new(:v6, format: :default), :default
      assert is_valid_uuid ExUUID.new(:v6, random: false)
    end

    test "creates version 6 uuid with format :hex" do
      assert is_valid_uuid ExUUID.new(:v6, format: :hex)
      assert uuid_format ExUUID.new(:v6, format: :hex), :hex
    end

    test "creates version 6 uuid with format :binary" do
      assert is_valid_uuid ExUUID.new(:v6, format: :binary)
      assert uuid_format ExUUID.new(:v6, format: :binary), :binary
    end
  end

  describe "new/4" do
    test "creates version 3 uuid" do
      assert is_valid_uuid ExUUID.new(:v3, namespace(), "abc")
      assert uuid_format ExUUID.new(:v3, namespace(), "abc"), :default
      assert is_valid_uuid ExUUID.new(:v3, namespace(), "abc", format: :default)
      assert uuid_format ExUUID.new(:v3, namespace(), "abc", format: :default), :default
    end

    test "creates version 3 uuid with format :hex" do
      assert is_valid_uuid ExUUID.new(:v3, namespace(), "abc", format: :hex)
      assert uuid_format ExUUID.new(:v3, namespace(), "abc", format: :hex), :hex
    end

    test "creates version 3 uuid with format :binary" do
      assert is_valid_uuid ExUUID.new(:v3, namespace(), "abc", format: :binary)
      assert uuid_format ExUUID.new(:v3, namespace(), "abc", format: :binary), :binary
    end

    test "creates version 5 uuid" do
      assert is_valid_uuid ExUUID.new(:v5, namespace(), "abc")
      assert uuid_format ExUUID.new(:v5, namespace(), "abc"), :default
      assert is_valid_uuid ExUUID.new(:v5, namespace(), "abc", format: :default)
      assert uuid_format ExUUID.new(:v5, namespace(), "abc", format: :default), :default
    end

    test "creates version 5 uuid with format :hex" do
      assert is_valid_uuid ExUUID.new(:v5, namespace(), "abc", format: :hex)
      assert uuid_format ExUUID.new(:v5, namespace(), "abc", format: :hex), :hex
    end

    test "creates version 5 uuid with format :binary" do
      assert is_valid_uuid ExUUID.new(:v5, namespace(), "abc", format: :binary)
      assert uuid_format ExUUID.new(:v5, namespace(), "abc", format: :binary), :binary
    end

    test "raises an exception for an invalid namespace" do
      assert_raise ArgumentError, "invalid namespace", fn ->
        ExUUID.new(:v3, <<7>>, "test")
      end
    end
  end

  describe "valid?/1" do
    test "returns false for an invalid uuid" do
      refute ExUUID.valid?("foo")
      refute ExUUID.valid?(@invalid_uuid)
    end
  end

  describe "version/1" do
    test "returns the version of an version 1 uuid" do
      assert :v1 |> ExUUID.new() |> ExUUID.version() == {:ok, 1}
      assert :v1 |> ExUUID.new(format: :hex) |> ExUUID.version() == {:ok, 1}
      assert :v1 |> ExUUID.new(format: :binary) |> ExUUID.version() == {:ok, 1}
    end

    test "returns the version of an version 3 uuid" do
      assert :v3 |> ExUUID.new(namespace(), "test") |> ExUUID.version() == {:ok, 3}
      assert :v3 |> ExUUID.new(namespace(), "test", format: :hex) |> ExUUID.version() == {:ok, 3}

      assert :v3 |> ExUUID.new(namespace(), "test", format: :binary) |> ExUUID.version() ==
               {:ok, 3}
    end

    test "returns the version of an version 4 uuid" do
      assert :v4 |> ExUUID.new() |> ExUUID.version() == {:ok, 4}
      assert :v4 |> ExUUID.new(format: :hex) |> ExUUID.version() == {:ok, 4}
      assert :v4 |> ExUUID.new(format: :binary) |> ExUUID.version() == {:ok, 4}
    end

    test "returns the version of an version 5 uuid" do
      assert :v5 |> ExUUID.new(namespace(), "test") |> ExUUID.version() == {:ok, 5}
      assert :v5 |> ExUUID.new(namespace(), "test", format: :hex) |> ExUUID.version() == {:ok, 5}

      assert :v5 |> ExUUID.new(namespace(), "test", format: :binary) |> ExUUID.version() ==
               {:ok, 5}
    end

    test "returns the version of an version 6 uuid" do
      assert :v6 |> ExUUID.new() |> ExUUID.version() == {:ok, 6}
      assert :v6 |> ExUUID.new(format: :hex) |> ExUUID.version() == {:ok, 6}
      assert :v6 |> ExUUID.new(format: :binary) |> ExUUID.version() == {:ok, 6}
    end

    test "returns :error for an invalid uuid" do
      assert ExUUID.version("foo") == :error
      assert ExUUID.version(@invalid_uuid) == :error
    end
  end

  describe "variant/1" do
    test "returns the variant of an uuid" do
      assert :v6 |> ExUUID.new() |> ExUUID.variant() == {:ok, :rfc4122}
      assert :v6 |> ExUUID.new(format: :hex) |> ExUUID.variant() == {:ok, :rfc4122}
      assert :v6 |> ExUUID.new(format: :binary) |> ExUUID.variant() == {:ok, :rfc4122}
    end

    test "returns :error for an invalid uuid" do
      assert ExUUID.variant("foo") == :error
      assert ExUUID.variant(@invalid_uuid) == :error
    end
  end

  describe "to_binary/1" do
    test "returns the uuid as binary from :default" do
      assert {:ok, uuid} = :v6 |> ExUUID.new() |> ExUUID.to_binary()
      assert is_valid_uuid uuid
      assert uuid_format uuid, :binary
    end

    test "returns the uuid as binary from :hex" do
      assert {:ok, uuid} = :v1 |> ExUUID.new(format: :hex) |> ExUUID.to_binary()
      assert is_valid_uuid uuid
      assert uuid_format uuid, :binary
    end

    test "returns the uuid as binary from :binary" do
      assert {:ok, uuid} = :v1 |> ExUUID.new(format: :binary) |> ExUUID.to_binary()
      assert is_valid_uuid uuid
      assert uuid_format uuid, :binary
    end
  end

  describe "to_string/2" do
    test "returns the uuid as string, format: :default" do
      assert {:ok, uuid} = :v1 |> ExUUID.new(format: :binary) |> ExUUID.to_string()
      assert is_valid_uuid uuid
      assert uuid_format uuid, :default
    end

    test "returns the uuid as string, format: :hex" do
      assert {:ok, uuid} = :v1 |> ExUUID.new(format: :binary) |> ExUUID.to_string(format: :hex)
      assert is_valid_uuid uuid
      assert uuid_format uuid, :hex
    end
  end

  defp is_valid_uuid(<<_::128>> = uuid) do
    with {:ok, str} <- ExUUID.to_string(uuid), do: is_valid_uuid(str) && ExUUID.valid?(str)
  end

  defp is_valid_uuid(<<_::256>> = uuid) do
    Regex.match?(~r/[0-9,a-f]{32}/, uuid) && ExUUID.valid?(uuid)
  end

  defp is_valid_uuid(<<_::288>> = uuid) do
    regex = ~r/[0-9,a-f]{8}-[0-9,a-f]{4}-[0-9,a-f]{4}-[0-9,a-f]{4}-[0-9,a-f]{12}/
    Regex.match?(regex, uuid) && ExUUID.valid?(uuid)
  end

  defp is_valid_uuid(_uuid), do: false

  defp uuid_format(<<_uuid::128>>, :binary), do: true
  defp uuid_format(<<_uuid::256>>, :hex), do: true
  defp uuid_format(<<_uuid::288>>, :default), do: true
  defp uuid_format(_uuid, _format), do: false

  defp namespace, do: Enum.random([:dns, :url, :oid, :x500, nil])
end
