defmodule Outbox.Structs.Request do
  @derive Jason.Encoder
  defstruct id: nil, text: nil, attachments: [], buttons: [], extra: nil
  require IEx

  def init(%{transport: transport} = context, params) do
    struct = struct(__MODULE__, params)

    extra =
      case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Outbox.Structs.Extra") do
        nil -> nil
        module -> struct(module, params[:extra])
      end

    {context, %{struct | extra: extra}}
  end
end
