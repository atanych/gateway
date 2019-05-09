defmodule Transports.Telegram.Outbox.Send do
  use BaseCommand

  def call({%{device: %{settings: %{"token" => token}}}, request}, [chat_id]) do
    request = %Ext.Sdk.Request{
      payload: %{
        text: request.text,
        chat_id: chat_id
      },
      options: %{url_params: token}
    }

    Sdk.Telegram.Client.send_message(request)
  end
end
