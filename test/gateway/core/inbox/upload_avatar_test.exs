defmodule Inbox.UploadAvatarTest do
  use GatewayWeb.ConnCase

  describe ".call" do
    test "viber_public" do
      with_mock Storage.PutAttachment, call: fn _, _, _ -> "/temp.original.jpg" end do
        device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

        client = Inbox.UploadAvatar.call({%{device: device}, %{avatar: "https://viber.com"}}, "viber_public")
        assert client.avatar == "/temp.original.jpg"
      end
    end

    test "avatar is nil" do
      device = build(:device, settings: %{"token" => "829411875:AAGCZ9-rDZzX_r5Vak86g7y0uQnrKIZzvvs"})

      client = Inbox.UploadAvatar.call({%{device: device}, %{avatar: nil}}, "viber_public")
      assert client.avatar == nil
    end
  end

  describe ".get_avatar" do
    client = Inbox.UploadAvatar.get_avatar({%{}, %{avatar: "https://viber.com"}}, "viber_public")
    assert client == %{url: "https://viber.com"}
  end
end
