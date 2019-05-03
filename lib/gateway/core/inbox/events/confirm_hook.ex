defmodule Inbox.Events.ConfirmHook do
  use BaseCommand

  def call({context, %{transport: transport} = params}) do
    module = String.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.ConfirmHook")

    # add to context.response = %Inbox.Response{format: :json, body: body, status: 400} or %Inbox.Response{format: :text, body: body, status: 400}
    module.call()
  end
end
