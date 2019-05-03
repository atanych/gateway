defmodule Inbox.BroadcastToVadesk do
  use BaseCommand

  def call({%{event: event} = context, request}) do
    Logger.warn("BROADCAST, #{inspect(request)}")
    Gateway.Repo.save!(event, %{status: :sent})
    {context, request}
  end
end
