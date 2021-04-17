# ExUUID
[![CI](https://github.com/hrzndhrn/ex_uuid/actions/workflows/elixir.yml/badge.svg)](https://github.com/hrzndhrn/ex_uuid/actions/workflows/elixir.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

UUID generator according to [RFC 4122](https://www.ietf.org/rfc/rfc4122.txt).

This lib is just a reimplementation of [elixir_uuid](https://hex.pm/packages/elixir_uuid)
respectively [uuid_utils](https://hex.pm/packages/uuid_utils) with a different API.
If you’re already use `elixir_uuid` or `uuid_utils` there’s no reason to change.

## Usage

UUID Version 1

```elixir
iex> ExUUID.new(:v1)
"edfb6844-8fab-11eb-b56d-5c3258947fdb"
iex> ExUUID.new(:v1, format: :hex)
"d6c6b68448fab11ebb56d5c3258947fdb"
iex> ExUUID.new(:v1, format: :binary)
<<237, 251, 104, 68, 143, 171, 17, 235, 181, 109, 92, 50, 88, 148, 127, 219>>
```

UUID Version 3

```elixir
iex> ExUUID.new(:v3, nil, "foo")
"d657f8eb-ad4f-3d7d-88ea-4c752dd6ccd2"
iex> ExUUID.new(:v3, :dns, "foo")
"3f46ae03-c654-36b0-a55d-cd0aa042c9f2"
iex> ExUUID.new(:v3, :x500, "foo")
"c3c8dbcd-8f60-3825-b42b-162fc311726f"
iex> ExUUID.new(:v3, :url, "foo")
"a5bf60bd-fe2d-3fac-bbd7-404751e6ca66"
iex> ExUUID.new(:v3, :oid, "foo")
"0c4a59ab-bf78-32ba-a4e0-da882fe4ddfa"
iex> ExUUID.new(:v3, :oid, "foo", format: :hex)
"0c4a59abbf7832baa4e0da882fe4ddfa"
```

UUID Version 4

```elixir
iex> ExUUID.new(:v4)
"edfb6844-8fab-11eb-b56d-5c3258947fdb"
iex> ExUUID.new(:v4, format: :hex)
"d6c6b68448fab11ebb56d5c3258947fdb"
iex> ExUUID.new(:v4, format: :binary)
<<237, 251, 104, 68, 143, 171, 17, 235, 181, 109, 92, 50, 88, 148, 127, 219>>
```

UUID Version 5

```elixir
iex> ExUUID.new(:v5, nil, "bar")
"313ce13e-b597-5858-ae13-29e46fea26e6"
iex> ExUUID.new(:v5, :dns, "bar")
"e8d5cf6d-de0f-5e77-9aa3-91093cdfbf62"
```

UUID Version 6

```elixir
iex> ExUUID.new(:v6)
"edfb6844-8fab-11eb-b56d-5c3258947fdb"
iex> ExUUID.new(:v6, format: :hex)
"d6c6b68448fab11ebb56d5c3258947fdb"
iex> ExUUID.new(:v6, format: :binary)
<<237, 251, 104, 68, 143, 171, 17, 235, 181, 109, 92, 50, 88, 148, 127, 219>>
```

`valid?/1`, `version/1`, `variant/1`

```elixir
iex> uuid = "edfb6844-8fab-11eb-b56d-5c3258947fdb"
"edfb6844-8fab-11eb-b56d-5c3258947fdb"
iex> ExUUID.valid?(uuid)
true
iex> ExUUID.version(uuid)
{:ok, 1}
iex> ExUUID.variant(uuid)
{:ok, :rfc4122}
```

Reformat

```elixir
iex> uuid = "edfb6844-8fab-11eb-b56d-5c3258947fdb"
"edfb6844-8fab-11eb-b56d-5c3258947fdb"
iex> {:ok, uuid} = ExUUID.to_binary(uuid)
{:ok,
 <<237, 251, 104, 68, 143, 171, 17, 235, 181, 109, 92, 50, 88, 148, 127, 219>>}
iex> ExUUID.to_string(uuid)
{:ok, "edfb6844-8fab-11eb-b56d-5c3258947fdb"}
iex> ExUUID.to_string(uuid, format: :hex)
{:ok, "edfb68448fab11ebb56d5c3258947fdb"}
```
