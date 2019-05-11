defmodule Outbox.Structs.Request do
  @derive Jason.Encoder
  defstruct id: nil, text: nil, attachments: [], extra: nil
  require IEx

  def init(%{transport: transport} = context, params) do
    struct = struct(__MODULE__, params)

    {context, %{struct | extra: Outbox.Structs.Extra.init(params[:extra])}}
  end
end
