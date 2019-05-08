defmodule Inbox.UnifyRequest do
  use BaseCommand

  def call(%{transport: transport, device_uniq_key: device_uniq_key} = params) do
    module = String.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Inbox.UnifyRequest")

    request =
      params
      |> module.call()
      |> expand_request(params)

    Logger.info("Unified Inbox request: #{inspect(request)}")
    request
  end

  def expand_request(%{device_uniq_key: nil} = request, params) do
    %{request | transport: params[:transport], device_uniq_key: params[:device_uniq_key]}
  end

  def expand_request(request, params), do: %{request | transport: params[:transport]}
end
