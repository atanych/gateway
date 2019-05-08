defmodule Inbox.SaveContactTest do
  use GatewayWeb.ConnCase

  describe ".call" do
    test "client exists" do
      with_mock Storage.PutAttachment, call: fn _, _, _ -> "/uploads/some.jpg" end do
        context = %{client: nil, device: insert(:device)}

        request = %{
          contact: %{avatar: "https://some.url"},
          transport: "viber_public"
        }

        {_context, request} = Inbox.SaveContact.call({context, request})
        assert request.contact.avatar == "/uploads/some.jpg"
      end
    end

    test "contact does not exist" do
      context = %{client: nil, device: nil}

      request = %{
        contact: nil,
        transport: "telegram"
      }

      {context, request} = Inbox.SaveContact.call({context, request})
      refute context.client
      refute context.device
      assert request == %{contact: nil, transport: "telegram"}
    end
  end
end
