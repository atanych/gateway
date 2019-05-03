defmodule Inbox.UnifyRequest do
  use BaseCommand

  def call(%{transport: transport} = request) do
    module = String.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.UnifyInboxRequest")
    request = module.call(request)
    Logger.info("Unified Inbox request: #{inspect(request)}")
    request
  end
end
