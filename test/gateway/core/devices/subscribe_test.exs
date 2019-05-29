defmodule Devices.SubscribeTest do
  use GatewayWeb.ConnCase

  test "viber" do
    with_mock Sdk.ViberPublic.Client,
      get_account_info: fn _ ->
        {:ok,
         %{
           "category" => "Local Businesses",
           "chat_flags" => [],
           "chat_hostname" => "SN-CHAT-05_",
           "country" => "US",
           "event_types" => [
             "subscribed",
             "unsubscribed",
             "webhook",
             "conversation_started",
             "action",
             "delivered",
             "failed",
             "message",
             "seen"
           ],
           "icon" =>
             "https://media-direct.cdn.viber.com/pg_download?pgtp=icons&dlid=0-04-01-9684d1ee0290bbc90e3a05212a23b99e1df3bc5e278848b018e2158e9a33ed8d&fltp=jpg&imsz=0000",
           "id" => "pa:5304742802618831828",
           "location" => %{"lat" => 40.7691018, "lon" => -73.96878},
           "members" => [
             %{
               "avatar" =>
                 "https://media-direct.cdn.viber.com/download_photo?dlid=_4tuCNTT5yZ5O55J29n1zAGOMc5t7pWXuc7l-zxSkkD_34q2-Ee8MgbGMFoe344eKxgLTKbuKXgm9E46KmHR5qwsion_uVAWgBKdK_s7w5v9BYvp8ew1ej7kYmqSwsDKokWs1w&fltp=jpg&imsz=0000",
               "id" => "cYRSvxQEZoysiOFatiYbWQ==",
               "name" => "Augusto",
               "role" => "admin"
             },
             %{
               "avatar" =>
                 "https://media-direct.cdn.viber.com/download_photo?dlid=_4tuCNTT5yZ5O55J29n1zAGON84475eR78rs_GBVxU7_3Yvr-ULpY13ANQ5DiY8ffRALQKG4dH8urU40KmPW4a8o342qv1YTgRaefPkxyp37V9u-4I8_ZxHOKrc-OhlP7Lmc1w&fltp=jpg&imsz=0000",
               "id" => "wAH/iUrD+rHAocQ8VQQhUg==",
               "name" => "atanych",
               "role" => "admin"
             }
           ],
           "name" => "Vadesk.io",
           "status" => 0,
           "status_message" => "ok",
           "subcategory" => "Computer & Electronics",
           "subscribers_count" => 3,
           "uri" => "testc4d",
           "webhook" => "https://be036e6e.ngrok.io/webhooks/inbox/viber_public/bbb"
         }}
      end,
      set_webhook: fn _ -> {:ok, %{}} end do
      device =
        build(:device,
          transport: :viber_public,
          settings: %{"token" => "499e3b7926e7d3d4-d1aa119865ef879c-63c8850708d82d10"}
        )

      {:ok, %{settings: settings}} = Devices.Subscribe.call(device)
      assert settings["name"] == "Vadesk.io"
      assert settings["url"] =~ "viber://pa?chatURI=testc4d"
    end
  end
end
