defmodule Inbox.IsValidRequestTest do
  use GatewayWeb.ConnCase

  describe "positive" do
    test "telegram" do
      assert Inbox.IsValidRequest.call(%{transport: "telegram", message: %{text: "111"}})
    end
    test "viber_public" do
      assert Inbox.IsValidRequest.call(%{event: "message", transport: "viber_public"})
    end

    test "livechat" do
      assert Inbox.IsValidRequest.call(%{transport: "livechat"})
    end
  end

  describe "negative" do
    test "telegram" do
      refute Inbox.IsValidRequest.call(%{transport: "telegram"})
    end
    test "viber_public" do
      refute Inbox.IsValidRequest.call(%{transport: "viber_public"})
    end
  end
end
