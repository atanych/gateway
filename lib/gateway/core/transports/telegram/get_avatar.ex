defmodule Transports.Telegram.GetAvatar do
  use BaseCommand

  def call({%{device: %{settings: %{"token" => token}}}, request}) do
    token
    |> get_file_id(request)
    |> Sdk.Telegram.Client.get_file_path_by_id(token)
  end

  def get_file_id(token, %{id: id}) do
    request = %Ext.Sdk.Request{payload: %{user_id: id, limit: 1}, options: %{url_params: token}}

    {:ok, %{"result" => %{"photos" => [photos]}}} = Sdk.Telegram.Client.get_user_profile_photos(request)

    %{"file_id" => file_id} = List.last(photos)

    file_id
  end
end
