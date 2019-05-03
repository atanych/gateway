defmodule Transports.Telegram.GetAvatar do
  use BaseCommand

  def call({%{device: %{settings: %{"token" => token}}}, request}) do
    with file_id <- get_file_id(token, request),
         file_path <- get_file_path(token, file_id) do
      "https://api.telegram.org/file/bot#{token}/#{file_path}"
    end
  end

  def get_file_id(token, %{client: %{id: id}}) do
    request = %Ext.Sdk.Request{payload: %{user_id: id, limit: 1}, options: %{url_params: token}}

    {:ok, %{"result" => %{"photos" => [photos]}}} = Sdk.Telegram.Client.get_user_profile_photos(request)

    %{"file_id" => file_id} = List.last(photos)

    file_id
  end

  def get_file_path(token, file_id) do
    request = %Ext.Sdk.Request{payload: %{file_id: file_id, limit: 1}, options: %{url_params: token}}

    {:ok, %{"result" => %{"file_path" => file_path}}} = Sdk.Telegram.Client.get_file(request)
    file_path
  end
end
