defmodule Inbox.UploadAttachmentsTest do
  use GatewayWeb.ConnCase

  describe ".call" do
    test "attachments are not filled" do
      {_, %{message: message}} = Inbox.UploadAttachments.call({1, %{message: %{id: "aaaa", attachments: []}}})
      assert message.id == "aaaa"
      assert message.attachments == []
    end

    test "attachments are filled" do
      with_mock Storage.PutAttachment, call: fn _, _, _ -> "/temp.original.jpg" end do
        {_, %{message: message}} =
          Inbox.UploadAttachments.call(
            {%{device: %{company_id: "222"}},
             %{transport: "livechat", message: %{id: "aaaa", attachments: ["file_id", "file_id1"]}}}
          )

        assert message.id == "aaaa"
        assert message.attachments == ["/temp.original.jpg", "/temp.original.jpg"]
      end
    end
  end
end
