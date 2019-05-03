defmodule Inbox.PerformEvent do
  use BaseCommand

  def call({context, %{event_type: event_type} = params}) do
    case Ext.Utils.Base.to_existing_atom("Elixir.Transports.Events.#{Macro.camelize(event_type)}") do
      nil -> {context, params}
      module -> module.call({context, params})
    end
  end
end
