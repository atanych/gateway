defmodule Inbox.PrepareResponse do
  def call({%{response: nil} = context, %{transport: transport} = params}) do
    case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.PrepareResponse") do
      nil -> %Inbox.Structs.Response{body: %{status: :ok}}
      module -> module.call({context, params})
    end
  end

  def call({%{response: response}, _}), do: response
end
