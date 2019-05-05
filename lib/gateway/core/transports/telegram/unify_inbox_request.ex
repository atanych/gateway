defmodule Transports.Telegram.UnifyInboxRequest do
  use BaseCommand

  def call(%{edited_message: edited_message} = params) when not is_nil(edited_message),
    do: call(params ||| %{message: edited_message, edited_message: nil})

  def call(%{message: %{chat: chat} = message, transport: transport} = params) do
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
          location: message[:location]
        },
        event_type: get_event_type(params),
        transport: transport,
        device_uniq_key: params[:device_uniq_key]
      })

    fill_attachments(request, params)
  end

  def get_event_type(%{message: %{edit_date: edit_date}}), do: "update_inbox"
  def get_event_type(_), do: "send_inbox"

  def fill_attachments(request, %{message: %{photo: photos}}) when is_list(photos) do
    photo = List.last(photos)

    Inbox.Structs.UnifiedRequest.add_attachment(request, %{
      id: photo.file_id,
      size: photo[:file_size],
      width: photo[:width],
      height: photo[:height]
    })
  end

  def fill_attachments(request, %{message: %{document: document}} = params) do
    Inbox.Structs.UnifiedRequest.add_attachment(request, %{
      id: document.file_id,
      name: document[:file_name],
      mime_type: document[:mime_type],
      type: "file",
      size: document[:file_size]
    })
  end

  def fill_attachments(request, _), do: request
end
