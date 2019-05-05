defmodule Transports.Telegram.IsValidInbox do
  use BaseCommand

  def call(%{message: %{location: location}}) when not is_nil(location), do: true
  def call(%{message: %{photo: photo}}) when not is_nil(photo), do: true
  def call(%{message: %{document: document}}) when not is_nil(document), do: true
  def call(%{edited_message: %{photo: photo}}) when not is_nil(photo), do: true
  def call(%{message: %{text: text}}) when not is_nil(text), do: true
  def call(%{edited_message: %{text: text}}) when not is_nil(text), do: true
  def call(_), do: false
end
