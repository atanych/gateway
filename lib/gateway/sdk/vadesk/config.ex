defmodule Sdk.Vadesk.Config do
  def data,
    do: %{
      base_url: System.get_env()["VADESK_URL"],
      sdk_name: "Vadesk",
      endpoints: %{
        gateway_events: %{
          type: :post,
          url: "/gateway_events"
        }
      }
    }
end
