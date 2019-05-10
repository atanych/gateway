defmodule Transports.Telegram.Inbox.UnifyRequestTest do
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
        update_id: 159_136_107
      }

      unified_request = Transports.Telegram.Inbox.UnifyRequest.call(request)
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

      unified_request = Transports.Telegram.Inbox.UnifyRequest.call(request)
      assert unified_request.event_type == "update_inbox"
      assert unified_request.message.text == "caption"
      assert unified_request.chat.id == "-352056954"
      assert unified_request.chat.type == "group"
    end

    test "location" do
      request = %{
        device_uniq_key: "aaa",
        message: %{
          chat: %{first_name: "atanych", id: 89_388_434, type: "private", username: "atanych"},
          date: 1_557_268_864,
          from: %{first_name: "atanych", id: 89_388_434, is_bot: false, language_code: "en", username: "atanych"},
          location: %{latitude: 53.884385, longitude: 27.432413},
          message_id: 144
        },
        transport: "telegram",
        update_id: 159_136_255
      }

      %{message: %{location: location}} = Transports.Telegram.Inbox.UnifyRequest.call(request)
      assert location == %{lat: 53.884385, lon: 27.432413}
    end

    test "contact" do
      request = %{
        device_uniq_key: "aaa",
        message: %{
          chat: %{first_name: "atanych", id: 89_388_434, type: "private", username: "atanych"},
          contact: %{first_name: "AAA", phone_number: "+375295563423", user_id: 413_720_323},
          date: 1_557_269_877,
          from: %{first_name: "atanych", id: 89_388_434, is_bot: false, language_code: "en", username: "atanych"},
          message_id: 145
        },
        transport: "telegram",
        update_id: 159_136_256
      }

      %{contact: contact} = Transports.Telegram.Inbox.UnifyRequest.call(request)
      assert contact.nickname == "AAA"
      assert contact.phone == "+375295563423"
      assert contact.id == 413_720_323
    end

    test "reply" do
      request = %{
        device_uniq_key: "aaa",
        message: %{
          chat: %{
            first_name: "atanych",
            id: 89_388_434,
            type: "private",
            username: "atanych"
          },
          date: 1_557_255_953,
          from: %{
            first_name: "atanych",
            id: 89_388_434,
            is_bot: false,
            language_code: "en",
            username: "atanych"
          },
          message_id: 134,
          reply_to_message: %{
            chat: %{
              first_name: "atanych",
              id: 89_388_434,
              type: "private",
              username: "atanych"
            },
            date: 1_557_254_339,
            from: %{
              first_name: "atanych",
              id: 89_388_434,
              is_bot: false,
              language_code: "en",
              username: "atanych"
            },
            message_id: 129,
            photo: [
              %{
                file_id: "AgADAgAD0asxG5iZkUpH4JZf7JVZPlNLXw8ABJabEEq8cI49ZZUEAAEC",
                file_size: 363,
                height: 34,
                width: 90
              },
              %{
                file_id: "AgADAgAD0asxG5iZkUpH4JZf7JVZPlNLXw8ABJPgfqysdeexZJUEAAEC",
                file_size: 558,
                height: 66,
                width: 176
              }
            ]
          },
          text: "222"
        },
        transport: "telegram",
        update_id: 159_136_245
      }

      %{reply: reply} = Transports.Telegram.Inbox.UnifyRequest.call(request)
      [attachment] = reply.message.attachments
      assert reply.chat.id == "89388434"
      assert reply.chat.type == "private"
      assert attachment.id == "AgADAgAD0asxG5iZkUpH4JZf7JVZPlNLXw8ABJPgfqysdeexZJUEAAEC"
    end
  end

  describe ".fill_attachments" do
    test "photo" do
      params = %{
        message: %{
          photo: [
            %{
              file_id: "AgADAgADtqoxG6WtaUq6bcNCH2Kp1pWqUQ8ABOKOyf0XowF4tOcCAAEC",
              file_size: 3084,
              height: 128,
              width: 83
            }
          ]
        }
      }

      request = %Inbox.Structs.UnifiedRequest{}

      %{message: %{attachments: [attachment]}} =
        Transports.Telegram.Inbox.UnifyRequest.fill_attachments(request, params)

      assert attachment.id == "AgADAgADtqoxG6WtaUq6bcNCH2Kp1pWqUQ8ABOKOyf0XowF4tOcCAAEC"
      assert attachment.size == 3084
      assert attachment.height == 128
      assert attachment.width == 83
      assert attachment.type == "image"
    end

    test "document" do
      params = %{
        message: %{
          document: %{
            file_id: "BQADAgADCwMAAmafcUqF9-QvRj1ypwI",
            file_name: "PGR ARCADE Configuration (22).xlsx",
            file_size: 13966,
            mime_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          }
        }
      }

      request = %Inbox.Structs.UnifiedRequest{}

      %{message: %{attachments: [attachment]}} =
        Transports.Telegram.Inbox.UnifyRequest.fill_attachments(request, params)

      assert attachment.id == "BQADAgADCwMAAmafcUqF9-QvRj1ypwI"
      assert attachment.name == "PGR ARCADE Configuration (22).xlsx"
      assert attachment.size == 13966
      assert attachment.mime_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      assert attachment.type == "file"
    end

    test "voice" do
      params = %{
        message: %{
          voice: %{
            duration: 1,
            file_id: "AwADAgADlAIAAmafeUplnjHF8lkdigI",
            file_size: 8800,
            mime_type: "audio/ogg"
          }
        }
      }

      request = %Inbox.Structs.UnifiedRequest{}

      %{message: %{attachments: [attachment]}} =
        Transports.Telegram.Inbox.UnifyRequest.fill_attachments(request, params)

      assert attachment.id == "AwADAgADlAIAAmafeUplnjHF8lkdigI"
      assert attachment.size == 8800
      assert attachment.duration == 1
      assert attachment.mime_type == "audio/ogg"
      assert attachment.type == "file"
    end

    test "sticker" do
      params = %{
        message: %{
          sticker: %{
            emoji: "👍",
            file_id: "CAADAgADxwADXM77Avb7B0PihcnjAg",
            file_size: 61790,
            height: 512,
            set_name: "DataMonsters",
            thumb: %{
              file_id: "AAQCABMRE7cNAARQ65OXhBcWuLtPAAIC",
              file_size: 7946,
              height: 128,
              width: 128
            },
            width: 512
          }
        }
      }

      request = %Inbox.Structs.UnifiedRequest{}

      %{message: %{attachments: [attachment]}} =
        Transports.Telegram.Inbox.UnifyRequest.fill_attachments(request, params)

      assert attachment.id == "CAADAgADxwADXM77Avb7B0PihcnjAg"
      assert attachment.size == 61790
      assert attachment.height == 512
      assert attachment.width == 512
      assert attachment.type == "image"
    end

    test "video" do
      params = %{
        message: %{
          video: %{
            duration: 1,
            file_id: "BAADAgADtQMAAo6QeUrnplWWHXqIigI",
            file_size: 174_293,
            height: 464,
            mime_type: "video/mp4",
            thumb: %{
              file_id: "AAQCABNwaIQPAATC6d6sfi6VCQIBAAIC",
              file_size: 12478,
              height: 175,
              width: 320
            },
            width: 848
          }
        }
      }

      request = %Inbox.Structs.UnifiedRequest{}

      %{message: %{attachments: [attachment]}} =
        Transports.Telegram.Inbox.UnifyRequest.fill_attachments(request, params)

      assert attachment.id == "BAADAgADtQMAAo6QeUrnplWWHXqIigI"
      assert attachment.size == 174_293
      assert attachment.height == 464
      assert attachment.duration == 1
      assert attachment.width == 848
      assert attachment.mime_type == "video/mp4"
      assert attachment.type == "file"
    end
  end
end
