defmodule Inbox.PrepareResponseTest do
  use GatewayWeb.ConnCase

  describe ".call" do
    test "response already exists" do
      context = %{response: %Inbox.Structs.Response{body: %{status: :fail}}}

      response = Inbox.PrepareResponse.call({context, %{}})
      assert response == %Inbox.Structs.Response{body: %{status: :fail}}
    end

    test "response is not filled" do
      context = %{response: nil}

      response = Inbox.PrepareResponse.call({context, %{transport: "telegram"}})
      assert response == %Inbox.Structs.Response{body: %{status: :ok}}
    end
  end
end
