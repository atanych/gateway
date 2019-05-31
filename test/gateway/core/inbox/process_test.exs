defmodule Inbox.ProcessTest do
  use GatewayWeb.ConnCase

  test ".call" do
    with_mock Inbox.BroadcastToVadesk, call: fn args -> args end do
      device = insert(:device, uniq_key: "rt4", transport: :telegram, settings: %{"token" => "asd"})

      params = %{
        transport: "telegram",
        device_uniq_key: "rt4",
        message: %{
          chat: %{
            first_name: "atanych",
            id: 89_388_434,
            type: "private",
            username: "atanych"
          },
          date: 1_556_640_471,
          from: %{
            first_name: "atanych",
            id: 89_388_434,
            is_bot: false,
            language_code: "en",
            username: "atanych"
          },
          message_id: 2,
          text: "hey"
        },
        update_id: 159_136_107
      }

      %{body: %{status: :ok}} = Inbox.Process.call(params)
      event = InboxEvent |> Gateway.Repo.one()
      assert event.device_id == device.id
      assert event.data["client"]["id"] == 89_388_434
      assert event.data["message"]["text"] == "hey"
    end
  end
end
