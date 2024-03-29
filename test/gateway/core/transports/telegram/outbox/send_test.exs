defmodule Transports.Telegram.Outbox.SendTest do
  use GatewayWeb.ConnCase

  describe "valid" do
    test "send message" do
      with_mock Sdk.Telegram.Client, send_message: fn _ -> {:ok, %{}} end do
        device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

        response =
          Transports.Telegram.Outbox.Send.call(
            %{device: device},
            [{:send_message, %{text: "aaa", chat_id: "ddd"}}]
          )

        assert response == [{:ok, %{}}]
      end
    end
  end

  test "invalid" do
    with_mock Sdk.Telegram.Client, send_message: fn _ -> {:error, %{reason: "INVALID TOKEN"}} end do
      device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

      response =
        Transports.Telegram.Outbox.Send.call(%{device: device}, [{:send_message, %{text: "aaa", chat_id: "ddd"}}])

      assert response == [{:error, %{reason: "INVALID TOKEN"}}]
    end
  end
end
