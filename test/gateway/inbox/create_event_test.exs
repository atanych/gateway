defmodule Inbox.CreateEventTest do
  use GatewayWeb.ConnCase

  test ".call" do
    context = %{client: insert(:client), device: insert(:device), event: nil}

    {%{event: event}, _} =
      Inbox.CreateEvent.call(
        {context,
         %{
           message: %{location: nil, text: "TEXT", attachments: [], id: 444},
           client: %{id: "ddd", uniq_key: "telegram/ddd"},
           chat: %{id: 111, type: "group"},
           event_type: "send_inbox"
         }}
      )

    assert event.text == "TEXT"
    assert event.external_id == "444"
    assert event.client_id
    assert event.device_id
    assert event.type == :send_inbox
    assert event.extra == %{chat_id: 111, type: "group"}
  end
end
