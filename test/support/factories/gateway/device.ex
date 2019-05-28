defmodule Factories.Gateway.Device do
  defmacro __using__(_opts) do
    quote do
      def device_factory do
        %Device{company_id: "98fba9b8-c7a9-4566-9afc-f7431edb9af0"}
      end
    end
  end
end
