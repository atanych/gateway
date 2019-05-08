defmodule Inbox.UnifyRequestTest do
  use GatewayWeb.ConnCase

  describe "expand_request" do
    test "device_uniq_key is found in request" do
      request =
        Inbox.UnifyRequest.expand_request(%{device_uniq_key: "aaa", transport: nil, message: %{text: "111"}}, %{
          transport: "telegram",
          device_uniq_key: "bbb"
        })

      assert request.device_uniq_key == "aaa"
      assert request.transport == "telegram"
      assert request.message == %{text: "111"}
    end

    test "device_uniq_key is not found in request" do
      request =
        Inbox.UnifyRequest.expand_request(%{device_uniq_key: nil, transport: nil, message: %{text: "111"}}, %{
          transport: "telegram",
          device_uniq_key: "bbb"
        })

      assert request.device_uniq_key == "bbb"
      assert request.transport == "telegram"
      assert request.message == %{text: "111"}
    end
  end

  test "call" do
    with_mock Transports.Telegram.Inbox.UnifyRequest, call: fn _ -> %Inbox.Structs.UnifiedRequest{} end do
      request = Inbox.UnifyRequest.call(%{transport: "telegram", device_uniq_key: "bbb"})
      assert request.device_uniq_key == "bbb"
      assert request.transport == "telegram"
    end
  end
end
