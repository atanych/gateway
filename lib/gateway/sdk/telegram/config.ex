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
        get_me: %{
          type: :get,
          url: fn token -> "/bot#{token}/getMe" end
        },
        get_user_profile_photos: %{
          type: :post,
          url: fn token -> "/bot#{token}/getUserProfilePhotos" end
        },
        get_file: %{
          type: :get,
          url: fn token -> "/bot#{token}/getFile" end
        },
        send_message: %{
          type: :post,
          url: fn token -> "/bot#{token}/sendMessage" end
        },
        send_photo: %{
          type: :post,
          url: fn token -> "/bot#{token}/sendPhoto" end
        },
        send_audio: %{
          type: :post,
          url: fn token -> "/bot#{token}/sendAudio" end
        },
        send_video: %{
          type: :post,
          url: fn token -> "/bot#{token}/sendVideo" end
        },
        send_document: %{
          type: :post,
          url: fn token -> "/bot#{token}/sendDocument" end
        }
      }
    }
end
