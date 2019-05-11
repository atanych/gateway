defmodule Transports.ViberPublic.Outbox.PreparePackagesTest do
  use GatewayWeb.ConnCase

  describe ".fill_chat_ids" do
    test "many chat ids" do
      response = Transports.ViberPublic.Outbox.PreparePackages.fill_chat_ids(%{}, ["4sfsf4", "3tdff"])

      assert response == %{broadcast_list: ["4sfsf4", "3tdff"]}
    end

    test "one chat id" do
      response = Transports.ViberPublic.Outbox.PreparePackages.fill_chat_ids(%{}, ["3tdff"])

      assert response == %{receiver: "3tdff"}
    end
  end

  describe ".get_method_by_chat_ids" do
    test "many chat ids" do
      response = Transports.ViberPublic.Outbox.PreparePackages.get_method_by_chat_ids(["4sfsf4", "3tdff"])

      assert response == :broadcast_message
    end

    test "one chat id" do
      response = Transports.ViberPublic.Outbox.PreparePackages.get_method_by_chat_ids(["3tdff"])

      assert response == :send_message
    end
  end

  describe ".fill_keyboard" do
    test "3 buttons" do
      keyboard = %{
        buttons: [%{text: "AAA"}, %{text: "BBB"}, %{text: "CCC"}],
        one_time: true
      }

      %{keyboard: keyboard} = Transports.ViberPublic.Outbox.PreparePackages.fill_keyboard(%{}, keyboard)

      assert keyboard == %{
               Type: "keyboard",
               Buttons: [
                 %{
                   ActionType: "reply",
                   Columns: 3,
                   Rows: 1,
                   ActionBody: "AAA",
                   Text: "AAA",
                   BgColor: "#FFFFFF"
                 },
                 %{
                   ActionType: "reply",
                   Columns: 3,
                   Rows: 1,
                   ActionBody: "BBB",
                   Text: "BBB",
                   BgColor: "#FFFFFF"
                 },
                 %{
                   ActionType: "reply",
                   Columns: 6,
                   Rows: 1,
                   ActionBody: "CCC",
                   Text: "CCC",
                   BgColor: "#FFFFFF"
                 }
               ]
             }
    end

    test "2 buttons" do
      keyboard = %{
        buttons: [%{text: "AAA"}, %{text: "BBB"}],
        one_time: true
      }

      %{keyboard: keyboard} = Transports.ViberPublic.Outbox.PreparePackages.fill_keyboard(%{}, keyboard)

      assert keyboard == %{
               Type: "keyboard",
               Buttons: [
                 %{
                   ActionType: "reply",
                   Columns: 3,
                   Rows: 1,
                   ActionBody: "AAA",
                   Text: "AAA",
                   BgColor: "#FFFFFF"
                 },
                 %{
                   ActionType: "reply",
                   Columns: 3,
                   Rows: 1,
                   ActionBody: "BBB",
                   Text: "BBB",
                   BgColor: "#FFFFFF"
                 }
               ]
             }
    end
  end

  describe ".call" do
    test "without attachments" do
      request = %{
        attachments: [],
        text: "AAAA",
        extra: %{
          keyboard: %{
            buttons: [%{text: "AAA"}],
            one_time: true
          }
        }
      }

      response = Transports.ViberPublic.Outbox.PreparePackages.call(request, ["4sfsf4"])

      assert response ==
               [
                 {:send_message,
                  %{
                    text: "AAAA",
                    receiver: "4sfsf4",
                    type: "text",
                    keyboard: %{
                      Type: "keyboard",
                      Buttons: [
                        %{
                          ActionType: "reply",
                          Columns: 6,
                          Rows: 1,
                          ActionBody: "AAA",
                          Text: "AAA",
                          BgColor: "#FFFFFF"
                        }
                      ]
                    }
                  }}
               ]
    end

    test "with 2 attachments" do
      request = %{
        attachments: [
          "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.pdf",
          "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.mp4"
        ],
        text: "AAAA",
        extra: %{
          keyboard: %{
            buttons: [],
            one_time: true
          }
        }
      }

      response = Transports.ViberPublic.Outbox.PreparePackages.call(request, ["4sfsf4"])

      assert response == [
               {:send_message,
                %{
                  receiver: "4sfsf4",
                  media: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.pdf",
                  type: "file"
                }},
               {:send_message,
                %{
                  receiver: "4sfsf4",
                  type: "video",
                  media: "https://content.onliner.by/news/970x485/27f19fa1286bd43196ce9aefa83224e4.mp4"
                }},
               {:send_message,
                %{
                  receiver: "4sfsf4",
                  text: "AAAA",
                  type: "text"
                }}
             ]
    end
  end
end
