defmodule Transports.Telegram.UnifyInboxRequest do
  use BaseCommand

  def call(%{edited_message: edited_message} = params) when not is_nil(edited_message),
    do: call(params ||| %{message: edited_message, edited_message: nil})

  def call(%{message: %{chat: chat} = message, transport: transport} = params) do
    params =
      Inbox.Structs.UnifiedRequest.init(%{
        chat: %{
          id: Ext.Utils.Base.to_str(chat[:id]),
          title: chat[:title],
          type: chat[:type]
        },
        client: %{
          id: message[:from][:id],
          uniq_key: "#{transport}/#{message[:from][:id]}",
          nickname: message[:from][:username],
          avatar: "SHOULD BE FILLED",
          lang: message[:from][:language_code]
        },
        message: %{
          id: message[:message_id],
          text: message[:text] || message[:caption],
          attachments: ["SHOULD BE FILLED"],
          location: message[:location]
        },
        event_type: get_event_type(params),
        transport: transport,
        device_uniq_key: params[:device_uniq_key]
      })

    params
  end

  def get_event_type(%{message: %{edit_date: edit_date}}), do: "update_inbox"
  def get_event_type(_), do: "send_inbox"
end
