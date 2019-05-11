defmodule Attachments.GetInfoByUrlTest do
  use GatewayWeb.ConnCase

  test ".call" do
    url = "https://avatars.mds.yandex.net/get-autoru-all/1684730/e6cee55672f8343f5542b193a30fec07/1200x900"
    response = Attachments.GetInfoByUrl.call(url)
    assert response == %{ext: "jpg", length: "149695", mime_type: "image/jpeg"}
  end
end
