defmodule Inbox.SaveClientTest do
  use GatewayWeb.ConnCase

  describe ".call" do
    test "client exists" do
      context = %{client: insert(:client, avatar: "/uploads/tmp.jpg")}

      {_context, request} = Inbox.SaveClient.call({context, %{client: %{avatar: nil}}})
      assert request.client.avatar == "/uploads/tmp.jpg"
    end

    test "client does not exist" do
      with_mock Transports.Telegram.GetAvatar, call: fn _ -> "https://images.pexels.com/temp" end do
        with_mock Sdk.Storage.Client, upload: fn _ -> {:ok, %{"path" => "/temp.original.jpg"}} end do
          context = %{client: nil, device: insert(:device)}

          request = %{
            transport: "telegram",
            client: %{nickname: "Mac", id: 1222, uniq_key: "telegram/1222", lang: "ru", avatar: nil}
          }

          {%{client: client}, request} = Inbox.SaveClient.call({context, request})
          assert client.avatar == "/temp.original.jpg"
          assert client.uniq_key == "telegram/1222"
          assert client.external_id == "1222"
          assert client.lang == "ru"
          assert client.nickname == "Mac"
          assert request.client.avatar == "/temp.original.jpg"
        end
      end
    end
  end
end
