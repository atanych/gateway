defmodule Gql.OutboxEvents.Resolver do
  require IEx

  def send(args, _info) do
    Outbox.Process.call(args)
    {:ok, :ok}
  end
end
