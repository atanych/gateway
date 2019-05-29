defmodule Gql.Devices.Resolver do
  @moduledoc false
  use Ext.Gql.Resolvers.Base
  require IEx

  def connect(%{id: id}, _info) do
    device = Gateway.Repo.get!(Device, id)

    case Devices.Subscribe.call(device) do
      {:error, _a} ->
        {:error, :invalid_data}

      {:ok, %{settings: settings}} ->
        device = Gateway.Repo.save!(device, %{settings: settings})

        {:ok, device}
    end
  end
end
