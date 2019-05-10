defmodule Factories.Gateway.OutboxEvent do
  defmacro __using__(_opts) do
    quote do
      def outbox_event_factory do
        %OutboxEvent{}
      end
    end
  end
end
