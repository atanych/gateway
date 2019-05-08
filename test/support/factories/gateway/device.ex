defmodule Factories.Gateway.Device do
  defmacro __using__(_opts) do
    quote do
      def device_factory do
        %Device{company_id: "3r2asd-43rsdfdf"}
      end
    end
  end
end
