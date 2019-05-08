defmodule Inbox.IsValidRequest do
  use BaseCommand

  def call(%{transport: transport} = params) do
    case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Inbox.IsValidInbox") do
      nil -> true
      module -> module.call(params)
    end
  end
end
