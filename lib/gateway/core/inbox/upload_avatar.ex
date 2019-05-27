defmodule Inbox.UploadAvatar do
  use BaseCommand

  def call({context, client_request}, transport) do
    {context, client_request}
    |> get_avatar(transport)
    |> put_to_storage({context, client_request})
    |> put_to_request(client_request)
  end

  def get_avatar({context, client_request}, transport) do
    case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Inbox.GetAvatar") do
      nil -> %{url: client_request.avatar}
      module -> %{url: module.call({context, client_request})}
    end
  end

  def put_to_storage(%{url: url}, {%{device: device}, _client_request}) when not is_nil(url) do
    Storage.PutAttachment.call(%{url: url}, "avatar", device.company_id)
  end

  def put_to_storage(_, _), do: nil

  def put_to_request(avatar_path, client_request) do
    %{client_request | avatar: avatar_path}
  end
end
