defmodule Transports.ViberPublic.IsValidInbox do
  use BaseCommand

  def call(%{event: "webhook"}), do: true
  def call(%{event: "message"}), do: true
  def call(_), do: false
end