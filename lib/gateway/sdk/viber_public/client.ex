defmodule Sdk.ViberPublic.Client do
  # https://developers.viber.com/docs/api/rest-bot-api/#webhooks
  use Ext.Sdk.BaseClient, endpoints: Map.keys(Sdk.ViberPublic.Config.data().endpoints)
  require IEx
  require Logger

  def handle_response(response, status) do
    try do
      case Poison.decode!(response) do
        %{"status" => 0} = response ->
          {status, response}

        response ->
          Logger.error(inspect(response))
          {:error, response}
      end
    rescue
      _ ->
        {status, response}
    end
  end
end
