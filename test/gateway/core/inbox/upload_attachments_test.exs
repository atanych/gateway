defmodule Inbox.UploadAttachmentsTest do
  use GatewayWeb.ConnCase

  describe ".call" do
    test "attachments are not filled" do
      {_, %{message: message}} =
        Inbox.UploadAttachments.call({1, %{reply: nil, transport: "livechat", message: %{id: "aaaa", attachments: []}}})

      assert message.id == "aaaa"
      assert message.attachments == []
    end

    test "attachments are filled" do
      with_mock Storage.PutAttachment, call: fn _, _, _ -> "/temp.original.jpg" end do
        {_, %{message: message}} =
          Inbox.UploadAttachments.call(
            {%{device: %{company_id: "222"}},
             %{
               reply: nil,
               transport: "livechat",
               message: %{
                 id: "aaaa",
                 attachments: [%{id: "file_id", path: nil, type: "image"}, %{id: "file_id1", path: nil, type: "image"}]
               }
             }}
          )

        assert message.id == "aaaa"

        assert message.attachments == [
                 %{id: "file_id", path: "/temp.original.jpg", type: "image"},
                 %{id: "file_id1", path: "/temp.original.jpg", type: "image"}
               ]
      end
    end
  end
end
