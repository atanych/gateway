defmodule Transports.Telegram.Outbox.PrepareReplyMarkupTest do
  use GatewayWeb.ConnCase

  describe "call" do
    test "existing keyboard" do
      keyboard = %{
        buttons: [%{text: "AAA"}, %{text: "BBB"}, %{text: "CCC"}],
        one_time: true
      }

      response = Transports.Telegram.Outbox.PrepareReplyMarkup.call(keyboard)

      assert response == %{
               keyboard: [[%{text: "AAA"}, %{text: "BBB"}], [%{text: "CCC"}]],
               resize_keyboard: true,
               one_time_keyboard: true
             }
    end

    test "no keyboard" do
      keyboard = %{buttons: [], one_time: false}

      response = Transports.Telegram.Outbox.PrepareReplyMarkup.call(keyboard)

      assert response == nil
    end
  end
end
