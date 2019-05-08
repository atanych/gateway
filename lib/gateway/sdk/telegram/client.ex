defmodule Sdk.Telegram.Client do
  # https://core.telegram.org/bots/api#available-methods
  use Ext.Sdk.BaseClient, endpoints: Map.keys(Sdk.Telegram.Config.data().endpoints)
  require IEx
  require Logger

  def get_file_url_by_id(nil, token), do: nil

  def get_file_url_by_id(file_id, token) do
    request = %Ext.Sdk.Request{payload: %{file_id: file_id, limit: 1}, options: %{url_params: token}}

    {:ok, %{"result" => %{"file_path" => file_path}}} = Sdk.Telegram.Client.get_file(request)
    "#{Sdk.Telegram.Config.data().base_url}/file/bot#{token}/#{file_path}"
  end
end
