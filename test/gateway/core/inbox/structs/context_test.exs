defmodule Inbox.Structs.ContextTest do
  use GatewayWeb.ConnCase

  setup do
    insert(:device, uniq_key: "UNIQ_KEY", transport: :viber_public, settings: %{b: 1})
    insert(:device, uniq_key: "UNIQ_KEY", transport: :telegram, settings: %{a: 1})
    insert(:client, uniq_key: "ddd")
    :ok
  end

  describe "init" do
    test "default behaviour" do
      {%{device: device, client: client}, _} =
        Inbox.Structs.Context.init(%{transport: "telegram", device_uniq_key: "UNIQ_KEY", client: %{uniq_key: "ddd"}})

      assert device.settings == %{"a" => 1}
      assert client
    end
  end
end
