defmodule Inbox.UnifyRequest do
  use BaseCommand

  def call(%{transport: transport, device_uniq_key: device_uniq_key} = request) do
    module = String.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.UnifyInboxRequest")
    request = module.call(request) ||| %{device_uniq_key: device_uniq_key, transport: transport}
    Logger.info("Unified Inbox request: #{inspect(request)}")
    request
  end
end
