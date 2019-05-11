defmodule Transports.Telegram.Outbox.PreparePackagesTest do
  use GatewayWeb.ConnCase

  describe "call" do
    test "attachments size == 0" do
      request = %{
        attachments: [],
        text: "AAAA",
        extra: %{
          keyboard: %{
            buttons: [%{text: "AAA"}, %{text: "BBB"}, %{text: "CCC"}],
            one_time: true
          }
        }
      }

      response = Transports.Telegram.Outbox.PreparePackages.call(request, ["4sfsf4"])

      assert response == [
               {:send_message,
                %{
                  chat_id: "4sfsf4",
                  text: "AAAA",
                  reply_markup: %{
                    keyboard: [[%{text: "AAA"}, %{text: "BBB"}], [%{text: "CCC"}]],
                    resize_keyboard: true,
                    one_time_keyboard: true
                  }
                }}
             ]
    end

    test "attachments size == 1" do
      request = %{
        attachments: [%{url: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.jpeg"}],
        text: "AAAA",
        extra: %{
          keyboard: %{
            buttons: [%{text: "AAA"}, %{text: "BBB"}, %{text: "CCC"}],
            one_time: true
          }
        }
      }

      response = Transports.Telegram.Outbox.PreparePackages.call(request, ["4sfsf4"])

      assert response == [
               {:send_photo,
                %{
                  chat_id: "4sfsf4",
                  caption: "AAAA",
                  photo: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.jpeg",
                  reply_markup: %{
                    keyboard: [[%{text: "AAA"}, %{text: "BBB"}], [%{text: "CCC"}]],
                    resize_keyboard: true,
                    one_time_keyboard: true
                  }
                }}
             ]
    end

    test "attachments size == 3" do
      request = %{
        attachments: [
          %{url: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.pdf"},
          %{url: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.mp4"},
          %{url: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.mp3"}
        ],
        text: "AAAA",
        extra: %{
          keyboard: %{
            buttons: [%{text: "AAA"}, %{text: "BBB"}, %{text: "CCC"}],
            one_time: true
          }
        }
      }

      response = Transports.Telegram.Outbox.PreparePackages.call(request, ["4sfsf4"])

      assert response == [
               {:send_document,
                %{
                  chat_id: "4sfsf4",
                  document: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.pdf"
                }},
               {:send_video,
                %{
                  chat_id: "4sfsf4",
                  video: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.mp4"
                }},
               {:send_audio,
                %{
                  chat_id: "4sfsf4",
                  caption: "AAAA",
                  audio: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.mp3",
                  reply_markup: %{
                    keyboard: [[%{text: "AAA"}, %{text: "BBB"}], [%{text: "CCC"}]],
                    resize_keyboard: true,
                    one_time_keyboard: true
                  }
                }}
             ]
    end
  end
end
