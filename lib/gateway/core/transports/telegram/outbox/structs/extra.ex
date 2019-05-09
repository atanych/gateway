defmodule Transports.Telegram.Outbox.Structs.Extra do
  @derive Jason.Encoder

  defstruct test: nil, buttons: []

  def init(params) do
    struct(__MODULE__, params)
  end
end
