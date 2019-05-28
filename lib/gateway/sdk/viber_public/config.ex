defmodule Sdk.ViberPublic.Config do
  def data,
    do: %{
      base_url: "https://chatapi.viber.com/pa",
      sdk_name: "Viber Public",
      endpoints: %{
        set_webhook: %{
          type: :post,
          url: "/set_webhook"
        },
        send_message: %{
          type: :post,
          url: "/send_message"
        },
        broadcast_message: %{
          type: :post,
          url: "/broadcast_message"
        },
        get_account_info: %{
          type: :get,
          url: "/get_account_info"
        }
      }
    }
end
