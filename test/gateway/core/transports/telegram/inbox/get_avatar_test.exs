defmodule Transports.Telegram.Inbox.GetAvatarTest do
  use GatewayWeb.ConnCase

  test "call" do
    device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

    url = Transports.Telegram.Inbox.GetAvatar.call({%{device: device}, %{id: 89_388_434}})
    assert url =~ "telegram"
  end
end
