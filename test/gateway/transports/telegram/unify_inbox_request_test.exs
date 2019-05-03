defmodule Transports.Telegram.UnifyInboxRequestTest do
  use GatewayWeb.ConnCase

  describe "call" do
    test "message" do
      request = %{
        transport: "telegram",
        message: %{
          chat: %{
            first_name: "atanych",
            id: 89_388_434,
            type: "private",
            username: "atanych"
          },
          date: 1_556_640_471,
          from: %{
            first_name: "atanych",
            id: 89_388_434,
            is_bot: false,
            language_code: "en",
            username: "atanych"
          },
          message_id: 2,
          text: "hey"
        },
        provider: "telegram",
        update_id: 159_136_107
      }

      unified_request = Transports.Telegram.UnifyInboxRequest.call(request)
      assert unified_request.event_type == "send_inbox"
    end

    test "update_message" do
      request = %{
        device_uniq_key: "aaa",
        edited_message: %{
          caption: "caption",
          chat: %{
            all_members_are_administrators: true,
            id: -352_056_954,
            title: "test!!!",
            type: "group"
          },
          date: 1_556_881_276,
          edit_date: 1_556_882_021,
          from: %{
            first_name: "atanych",
            id: 89_388_434,
            is_bot: false,
            language_code: "en",
            username: "atanych"
          },
          message_id: 26
        },
        transport: "telegram",
        update_id: 159_136_130
      }

      unified_request = Transports.Telegram.UnifyInboxRequest.call(request)
      assert unified_request.event_type == "update_inbox"
      assert unified_request.message.text == "caption"
      assert unified_request.chat.id == "-352056954"
      assert unified_request.chat.type == "group"
    end
  end
end
