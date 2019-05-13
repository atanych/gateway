defmodule Outbox.Structs.KeyboardButton do
  defstruct text: nil
end

alias Outbox.Structs.KeyboardButton

defmodule Outbox.Structs.Keyboard do
  defstruct buttons: [], one_time: true
  import Ext.Utils.Map

  def init(params \\ %{}) do
    buttons = (params[:buttons] || []) |> Enum.map(fn button -> struct(KeyboardButton, button) end)
    struct(__MODULE__, params ||| %{buttons: buttons})
  end
end

alias Outbox.Structs.Keyboard

defmodule Outbox.Structs.Extra do
  @derive Jason.Encoder
  import Ext.Utils.Map
  defstruct keyboard: %{}

  def init(params) do
    struct(
      __MODULE__,
      params ||| %{keyboard: Keyboard.init(params[:keyboard] || %{})}
    )
  end
end
