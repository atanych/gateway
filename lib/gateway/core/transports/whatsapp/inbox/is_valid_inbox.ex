defmodule Transports.Whatsapp.Inbox.IsValidInbox do
  use BaseCommand

  def call(%{messages: messages}) when not is_nil(messages), do: true
  def call(_), do: false
end
