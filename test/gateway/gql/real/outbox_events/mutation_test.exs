defmodule Gql.Real.OutboxEvents.MutationTest do
  use GatewayWeb.ConnCase
  require IEx

  @mutation """
  mutation sendOutboxEvent {
  sendOutboxEvent(
    chatIds:["wAH/iUrD+rHAocQ8VQQhUg=="],
    deviceId:"82ac1164-7e7d-4f1e-b161-ee3005d65f02",
    event: {
      id: "aser2r-0296-47eb-b86e-d45acd0e788",
      text: "HA_HA_HA",
      attachments: [
        {
          url:"https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.jpeg"
        }, {
          url:"https://avatars.mds.yandex.net/get-autoru-all/1684730/e6cee55672f8343f5542b193a30fec07/1200x900",
          name: "VASJA"
        }
      ],
      extra: {
        keyboard: {
          buttons: [
            {
              text: "button 1"
            },
            {
              text: "button 2"
            }
          ]
        }
      }
    })
  }
  """

  test "send outbox", %{conn: conn} do
    with_mock Sdk.ViberPublic.Client, send_message: fn _ -> {:ok, %{"status" => 0}} end do
      insert(:device,
        id: "82ac1164-7e7d-4f1e-b161-ee3005d65f02",
        transport: :viber_public,
        settings: %{"token" => "asd"}
      )

      conn |> graphql_query(query: @mutation)
      outbox_event = Gateway.Repo.one(OutboxEvent)
      assert outbox_event.device_id == "82ac1164-7e7d-4f1e-b161-ee3005d65f02"
      assert outbox_event.external_id == "aser2r-0296-47eb-b86e-d45acd0e788"
      assert outbox_event.status == :sent
    end
  end
end
