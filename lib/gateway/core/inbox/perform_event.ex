defmodule Inbox.PerformEvent do
  use BaseCommand

  def call({context, %{event_type: event_type, transport: transport} = params}) do
    case Ext.Utils.Base.to_existing_atom(
           "Elixir.Transports.#{Macro.camelize(transport)}.Inbox.Events.#{Macro.camelize(event_type)}"
         ) do
      nil -> {context, params}
      module -> module.call({context, params})
    end
  end
end
