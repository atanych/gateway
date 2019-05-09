defmodule Outbox.Structs.ContextTest do
  use GatewayWeb.ConnCase

  setup do
    params = %{
      device_id: "5b1e9d2b-0296-47eb-b86e-d45acd0e7888",
      event: %{
        id: "aser2r-0296-47eb-b86e-d45acd0e788",
        text: "Hello Guys",
        attachments: [],
        extra: %{test: 11}
      },
      chat_ids: ["jpDfwqU13FdiJSt0WnTSTA==", "wAH/iUrD+rHAocQ8VQQhUg=="]
    }

    %{params: params}
  end

  describe ".init" do
    test "broadcasted transports", %{params: params} do
      insert(:device,
        id: "5b1e9d2b-0296-47eb-b86e-d45acd0e7888",
        transport: :viber_public,
        settings: %{"token" => "asd"}
      )

      %{events: [event]} = context = Outbox.Structs.Context.init(params)
      assert context.device.id == "5b1e9d2b-0296-47eb-b86e-d45acd0e7888"
      assert context.transport == "viber_public"
      assert event.external_id == "aser2r-0296-47eb-b86e-d45acd0e788"
      assert event.data == params
      assert event.chat_ids == ["jpDfwqU13FdiJSt0WnTSTA==", "wAH/iUrD+rHAocQ8VQQhUg=="]
      assert event.device_id == "5b1e9d2b-0296-47eb-b86e-d45acd0e7888"
    end

    test "other transports", %{params: params} do
      insert(:device,
        id: "5b1e9d2b-0296-47eb-b86e-d45acd0e7888",
        transport: :telegram,
        settings: %{"token" => "asd"}
      )

      %{events: [event_1, event_2]} = context = Outbox.Structs.Context.init(params)
      assert context.device.id == "5b1e9d2b-0296-47eb-b86e-d45acd0e7888"
      assert context.transport == "telegram"
      assert event_1.external_id == "aser2r-0296-47eb-b86e-d45acd0e788"
      assert event_1.chat_ids == ["jpDfwqU13FdiJSt0WnTSTA=="]
      assert event_2.external_id == "aser2r-0296-47eb-b86e-d45acd0e788"
      assert event_2.chat_ids == ["wAH/iUrD+rHAocQ8VQQhUg=="]
      assert event_1.device_id == "5b1e9d2b-0296-47eb-b86e-d45acd0e7888"
    end
  end
end
