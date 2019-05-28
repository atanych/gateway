defmodule Outbox.Structs.RequestTest do
  use GatewayWeb.ConnCase

  test ".init" do
    params = %{
      id: "aser2r-0296-47eb-b86e-d45acd0e788",
      text: "Hello Guys",
      attachments: [%{url: "http://sss.com"}],
      extra: %{keyboard: %{one_time: false, buttons: [%{text: "aa"}, %{text: "bb"}]}}
    }

    {_context, request} = Outbox.Structs.Request.init(%{transport: "telegram"}, params)
    [attachment] = request.attachments
    assert request.id == "aser2r-0296-47eb-b86e-d45acd0e788"
    assert request.text == "Hello Guys"
    assert request.extra.keyboard.one_time == false
    assert %{url: "http://sss.com", name: nil} = attachment
    assert [%{text: "aa"}, %{text: "bb"}] = request.extra.keyboard.buttons
  end
end
