defmodule Transports.Telegram.SubscribeTest do
  use GatewayWeb.ConnCase

  test "call" do
    with_mock Sdk.Telegram.Client,
      get_me: fn _ ->
        {:ok,
         %{
           "ok" => true,
           "result" => %{
             "first_name" => "my_bot",
             "id" => 829_411_875,
             "is_bot" => true,
             "username" => "my_bot"
           }
         }}
      end,
      set_webhook: fn _ -> {:ok, %{}} end do
      device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

      {:ok, %{settings: settings}} = Transports.Telegram.Subscribe.call(device)
      assert settings["name"] == "my_bot"
      assert settings["url"] =~ "https://t.me/my_bot"
    end
  end
end
