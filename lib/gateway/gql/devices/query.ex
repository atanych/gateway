defmodule Gql.Devices.Query do
  use Absinthe.Schema.Notation
  require IEx

  object :device do
    field :id, non_null(:string)
    field :uniq_key, :string
    field :transport, :string
    field :settings, :json
    field :status, :string
  end
end
