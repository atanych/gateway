defmodule Outbox.Structs.RequestTest do
  use GatewayWeb.ConnCase

  test ".init" do
    params = %{
      id: "aser2r-0296-47eb-b86e-d45acd0e788",
      text: "Hello Guys",
      attachments: [],
      extra: %{test: 11, buttons: ["aa"]}
    }

    {_context, request} = Outbox.Structs.Request.init(%{transport: "telegram"}, params)
    assert request.id == "aser2r-0296-47eb-b86e-d45acd0e788"
    assert request.text == "Hello Guys"
    assert request.extra.test == 11
    assert request.extra.buttons == ["aa"]
  end
end
