defmodule Inbox.Structs.Context do
  defstruct response: nil, device: nil, client: nil, event: nil

  def init(request) do
    {%__MODULE__{device: get_device(request), client: get_client(request)}, request}
  end

  def get_device(%{device_uniq_key: uniq_key, transport: transport}) do
    Device |> Gateway.Repo.get_by(uniq_key: uniq_key, transport: transport)
  end

  def get_client(%{client: %{uniq_key: uniq_key}}), do: Client |> Gateway.Repo.get_by(uniq_key: uniq_key)
end
