defmodule Factories.Gateway.Device do
  defmacro __using__(_opts) do
    quote do
      def device_factory do
        %Device{}
      end
    end
  end
end
