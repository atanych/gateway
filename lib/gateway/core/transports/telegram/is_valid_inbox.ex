defmodule Transports.Telegram.IsValidInbox do
  use BaseCommand

  def call(%{message: %{location: location}}) when not is_nil(location), do: true
  def call(%{message: %{photo: photo}}) when not is_nil(photo), do: true
  def call(%{message: %{document: document}}) when not is_nil(document), do: true
  def call(%{message: %{voice: voice}}) when not is_nil(voice), do: true
  def call(%{message: %{sticker: sticker}}) when not is_nil(sticker), do: true
  def call(%{message: %{video: video}}) when not is_nil(video), do: true
  def call(%{message: %{contact: contact}}) when not is_nil(contact), do: true
  def call(%{edited_message: %{photo: photo}}) when not is_nil(photo), do: true
  def call(%{message: %{text: text}}) when not is_nil(text), do: true
  def call(%{edited_message: %{text: text}}) when not is_nil(text), do: true
  def call(_), do: false
end
