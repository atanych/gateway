defmodule Outbox.SendTest do
  use GatewayWeb.ConnCase

  test "valid" do
    event_1 = insert(:outbox_event, chat_ids: ["ddddd"])
    event_2 = insert(:outbox_event, chat_ids: ["ddddd"])

    with_mock Transports.Telegram.Outbox.Send, call: fn _, _ -> [{:ok, %{}}] end do
      device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

      Outbox.Send.call(
        {%{events: [event_1, event_2], transport: "telegram"},
         %{text: "aaa", attachments: [], extra: %{keyboard: %{buttons: []}}}}
      )

      event_1 = Gateway.Repo.reload(event_1)
      event_2 = Gateway.Repo.reload(event_2)
      assert event_1.status == :sent
      assert event_2.status == :sent
    end
  end

  test "invalid" do
    event = insert(:outbox_event, chat_ids: ["ddddd"])

    with_mock Transports.Telegram.Outbox.Send, call: fn _, _ -> [{:error, %{reason: "INVALID TOKEN"}}] end do
      device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

      Outbox.Send.call(
        {%{events: [event], transport: "telegram"}, %{text: "aaa", attachments: [], extra: %{keyboard: %{buttons: []}}}}
      )

      event = Gateway.Repo.reload(event)
      assert event.status == :failed
      assert event.meta == inspect([{:error, %{reason: "INVALID TOKEN"}}])
    end
  end
end
