defmodule Sdk.ViberPublic.Config do
  def data,
    do: %{
      base_url: "https://chatapi.viber.com/pa",
      sdk_name: "Viber Public",
      endpoints: %{
        set_webhook: %{
          type: :post,
          url: "/set_webhook"
        }
      }
    }
end
