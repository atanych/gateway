defmodule Sdk.Telegram.Config do
  def data,
    do: %{
      base_url: "https://api.telegram.org",
      sdk_name: "Telegram",
      endpoints: %{
        set_webhook: %{
          type: :post,
          url: fn token -> "/bot#{token}/setWebhook" end
        },
        get_user_profile_photos: %{
          type: :post,
          url: fn token -> "/bot#{token}/getUserProfilePhotos" end
        },
        get_file: %{
          type: :get,
          url: fn token -> "/bot#{token}/getFile" end
        }
      }
    }
end
