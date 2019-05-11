defmodule Transports.ViberPublic.Outbox.SendTest do
  use GatewayWeb.ConnCase

  describe "valid" do
    test "send message" do
      with_mock Sdk.ViberPublic.Client, send_message: fn _ -> {:ok, %{}} end do
        device = build(:device, settings: %{"token" => "499e3b7926e7d3d4-d1aa119865ef879c-63c8850708d82d10"})

        Transports.ViberPublic.Outbox.Send.call(%{device: device}, [{:send_message, %{text: "ddd", receiver_id: "xxx"}}])

        assert called(Sdk.ViberPublic.Client.send_message(:_))
      end
    end

    test "broadcast message" do
      with_mock Sdk.ViberPublic.Client, broadcast_message: fn _ -> {:ok, %{}} end do
        device = build(:device, settings: %{"token" => "499e3b7926e7d3d4-d1aa119865ef879c-63c8850708d82d10"})

        Transports.ViberPublic.Outbox.Send.call(%{device: device}, [
          {:broadcast_message, %{text: "ddd", receiver_id: "xxx"}}
        ])

        assert called(Sdk.ViberPublic.Client.broadcast_message(:_))
      end
    end
  end
end
