defmodule Outbox.Send do
  use BaseCommand

  def call({%{events: events, transport: transport} = context, request} = args) do
    Enum.each(events, fn event ->
      module = Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Outbox.Send")
      packages = prepare_packages(args, event.chat_ids)
      response = module.call(context, packages)

      if(Enum.all?(response, fn {status, _} -> status == :ok end)) do
        Gateway.Repo.save!(event, %{status: :sent})
      else
        Logger.error(inspect(response), transport: transport)
        Gateway.Repo.save!(event, %{status: :failed, meta: inspect(response)})
      end
    end)

    args
  end

  def prepare_packages({%{events: events, transport: transport}, request} = args, chat_ids) do
    module = Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.Outbox.PreparePackages")
    module.call(request, chat_ids)
  end
end
