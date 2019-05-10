defmodule Outbox.Send do
  use BaseCommand

  def call({%{events: events, transport: transport}, request} = args) do
    Enum.each(events, fn event ->
      module = Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Outbox.Send")

      case module.call(args, event.chat_ids) do
        {:error, message} ->
          Logger.error(inspect(message), transport: transport)
          Gateway.Repo.save!(event, %{status: :failed, meta: inspect(message)})

        {:ok, message} ->
          Gateway.Repo.save!(event, %{status: :sent})
      end
    end)
  end
end
