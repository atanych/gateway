defmodule Outbox.ProcessTest do
  use GatewayWeb.ConnCase

  test ".call" do
    device =
      insert(:device, id: "5b1e9d2b-0296-47eb-b86e-d45acd0e7888", transport: :telegram, settings: %{"token" => "asd"})

    params = %{
      device_id: "5b1e9d2b-0296-47eb-b86e-d45acd0e7888",
      event: %{
        id: "aser2r-0296-47eb-b86e-d45acd0e788",
        text: "Hello Guys",
        attachments: [],
        extra: %{test: 11, buttons: []}
      },
      chat_ids: ["vbp/jpDfwqU13FdiJSt0WnTSTA==", "vbp/wAH/iUrD+rHAocQ8VQQhUg=="]
    }

    Outbox.Process.call(params)
  end
end
