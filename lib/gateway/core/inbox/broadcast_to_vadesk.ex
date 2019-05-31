defmodule Inbox.BroadcastToVadesk do
  use BaseCommand

  def call({%{event: event} = context, request}) do
    api_request = %Ext.Sdk.Request{payload: request}

    case Sdk.Vadesk.Client.gateway_events(api_request) do
      {:ok, _response} -> Gateway.Repo.save!(event, %{status: :sent})
      {:error, response} -> Gateway.Repo.save!(event, %{status: :failed, meta: inspect(response)})
    end

    {context, request}
  end
end
