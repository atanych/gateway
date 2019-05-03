defmodule Factories.Gateway.Client do
  defmacro __using__(_opts) do
    quote do
      def client_factory do
        %Client{}
      end
    end
  end
end
