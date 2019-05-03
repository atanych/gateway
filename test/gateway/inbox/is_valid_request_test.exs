defmodule Inbox.IsValidRequestTest do
  use GatewayWeb.ConnCase

  describe "positive" do
    test "telegram" do
      assert Inbox.IsValidRequest.call(%{transport: "telegram", message: %{text: "111"}})
    end

    test "livechat" do
      assert Inbox.IsValidRequest.call(%{transport: "livechat"})
    end
  end

  describe "negative" do
    test "telegram" do
      refute Inbox.IsValidRequest.call(%{transport: "telegram"})
    end
  end
end
