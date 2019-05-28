defmodule Devices.Subscribe do
  use BaseCommand

  def call(device) do
    transport_module = device.transport |> Ext.Utils.Base.to_str() |> Macro.camelize()

    case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{transport_module}.Subscribe") do
      nil -> raise "Should be implemented for transport #{device.transport}"
      module -> module.call(device)
    end
  end
end
