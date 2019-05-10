defmodule Transports.Telegram.Outbox.PrepareReplyMarkup do
  use BaseCommand

  def call(%{buttons: []}), do: nil

  def call(%{buttons: buttons, one_time: one_time}) do
    %{
      keyboard: Enum.chunk_every(buttons, 2),
      resize_keyboard: true,
      one_time_keyboard: one_time
    }
  end
end
