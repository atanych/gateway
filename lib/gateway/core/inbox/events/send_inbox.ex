defmodule Inbox.Events.SendInbox do
  use BaseCommand

  def call({context, params}) do
    Inbox.SaveClient.call({context, params})
    {context, params}
  end
end
