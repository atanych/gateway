defmodule Transports.Telegram.UnifyInboxRequest do
  use BaseCommand

  def call(%{edited_message: edited_message} = params) when not is_nil(edited_message),
    do: call(params ||| %{message: edited_message, edited_message: nil})

  def call(%{message: %{chat: chat} = message, transport: transport} = params) do
    params
    |> init_request()
    |> fill_attachments(params)
    |> fill_contact(params)
    |> fill_location(params)
    |> fill_reply(params)
  end

  def init_request(%{message: %{chat: chat} = message, transport: transport} = params) do
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
  end

  def get_event_type(%{message: %{edit_date: edit_date}}), do: "update_inbox"
  def get_event_type(_), do: "send_inbox"

  def fill_location(request, %{message: %{location: %{latitude: latitude, longitude: longitude}}}) do
    %{request | message: %{request.message | location: %{lat: latitude, lon: longitude}}}
  end

  def fill_location(request, _), do: request

  def fill_contact(request, %{message: %{contact: contact}}) when not is_nil(contact) do
    Inbox.Structs.UnifiedRequest.add_contact(request, %{
      id: contact[:user_id],
      nickname: contact[:first_name],
      phone: contact[:phone_number]
    })
  end

  def fill_contact(request, _), do: request

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

  def fill_attachments(request, %{message: %{voice: voice}} = params) do
    Inbox.Structs.UnifiedRequest.add_attachment(request, %{
      id: voice.file_id,
      mime_type: voice[:mime_type],
      duration: voice[:duration],
      type: "file",
      size: voice[:file_size]
    })
  end

  def fill_attachments(request, %{message: %{video: video}} = params) do
    Inbox.Structs.UnifiedRequest.add_attachment(request, %{
      id: video.file_id,
      mime_type: video[:mime_type],
      duration: video[:duration],
      type: "file",
      width: video[:width],
      height: video[:height],
      size: video[:file_size]
    })
  end

  def fill_attachments(request, %{message: %{sticker: sticker}} = params) do
    Inbox.Structs.UnifiedRequest.add_attachment(request, %{
      id: sticker.file_id,
      width: sticker[:width],
      height: sticker[:height],
      type: "image",
      size: sticker[:file_size]
    })
  end

  def fill_attachments(request, _), do: request

  def fill_reply(request, %{message: %{reply_to_message: reply_to_message}, transport: transport}) do
    %{request | reply: __MODULE__.call(%{message: reply_to_message, transport: transport})}
  end

  def fill_reply(request, _), do: request
end
