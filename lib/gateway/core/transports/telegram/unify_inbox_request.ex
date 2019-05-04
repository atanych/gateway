defmodule Transports.Telegram.UnifyInboxRequest do
  use BaseCommand

  def call(%{edited_message: edited_message} = request) when not is_nil(edited_message),
    do: call(request ||| %{message: edited_message, edited_message: nil})

  def call(%{message: %{chat: chat} = message, transport: transport} = request) do
    request =
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
          lang: message[:from][:language_code]
        },
        message: %{
          id: message[:message_id],
          text: message[:text] || message[:caption],
          attachments: get_attachments(request),
          location: message[:location]
        },
        event_type: get_event_type(request),
        transport: transport,
        device_uniq_key: request[:device_uniq_key]
      })

    request
  end

  def get_event_type(%{message: %{edit_date: edit_date}}), do: "update_inbox"
  def get_event_type(_), do: "send_inbox"

  def get_attachments(%{message: %{photo: photos}}) when is_list(photos) do
    %{file_id: file_id} = List.last(photos)
    [file_id]
  end

  def get_attachments(_), do: []
end
