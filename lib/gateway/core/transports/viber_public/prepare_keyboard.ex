defmodule Transports.ViberPublic.Outbox.PrepareKeyboard do
  use BaseCommand

  def call(%{buttons: []}), do: nil

  def call(%{buttons: buttons}) do
    buttons_length = length(buttons)

    buttons =
      buttons
      |> Enum.with_index()
      |> Enum.map(fn {%{text: text}, index} ->
        %{
          ActionType: "reply",
          Columns: get_column_size(index, buttons_length),
          Rows: 1,
          ActionBody: text,
          Text: text,
          BgColor: "#FFFFFF"
        }
      end)

    %{Type: "keyboard", Buttons: buttons}
  end

  def get_column_size(index, length) when rem(length, 2) == 1 and index + 1 == length, do: 6
  def get_column_size(_index, _length), do: 3
end
