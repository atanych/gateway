defmodule Inbox.Structs.Context do
  defstruct response: nil, device: nil, client: nil, event: nil
  require IEx
  def init(%{device_uniq_key: nil}), do: raise("device uniq key is nil")

  def init(request) do
    {%__MODULE__{device: get_device(request), client: get_client(request)}, request}
  end

  def get_device(%{device_uniq_key: uniq_key, transport: transport}) do
    case Device |> Gateway.Repo.get_by(uniq_key: uniq_key, transport: transport) do
      nil -> raise "Device is not found: transport=#{transport}, uniq_key=#{uniq_key}"
      device -> device
    end
  end

  def get_client(%{client: %{uniq_key: uniq_key}}),
    do: Client |> Gateway.Repo.where(uniq_key: uniq_key) |> Gateway.Repo.first()
end
