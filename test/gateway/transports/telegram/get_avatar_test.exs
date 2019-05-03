defmodule Transports.Telegram.GetAvatarTest do
  use GatewayWeb.ConnCase

  describe "call" do
    test "message" do
      device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

      Transports.Telegram.GetAvatar.call({%{device: device}, %{client: %{id: 89_388_434}}})
    end
  end
end
