defmodule Transports.ViberPublic.Inbox.IsValidInbox do
  use BaseCommand

  def call(%{event: "webhook"}), do: true
  def call(%{event: "message"}), do: true
  def call(%{event: "seen"}), do: true
  def call(_), do: false
end
