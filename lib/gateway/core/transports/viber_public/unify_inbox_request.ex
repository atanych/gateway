defmodule Transports.ViberPublic.UnifyInboxRequest do
  use BaseCommand

  def call(%{event: "webhook"}), do: Inbox.Structs.UnifiedRequest.init(%{event_type: "confirm_hook"})

  def call(%{message: message, sender: sender, message_token: message_token} = params) do
    Inbox.Structs.UnifiedRequest.init(%{
      event_type: "send_inbox",
      client: %{
        id: sender[:id],
        avatar: sender[:avatar],
        uniq_key: "vp/#{sender[:id]}",
        lang: sender[:language],
        country: sender[:country],
        nickname: sender[:name]
      },
      chat: %{
        id: sender[:id]
      },
      message: %{
        id: message_token,
        text: message[:text],
        location: message[:location]
      }
    })
    |> fill_contact(params)
    |> fill_attachments(params)
  end

  def fill_contact(request, %{message: %{contact: contact, type: "contact"}}) do
    Inbox.Structs.UnifiedRequest.add_contact(request, %{
      avatar: contact[:avatar],
      nickname: contact[:name],
      phone: contact[:phone_number]
    })
  end

  def fill_contact(request, _), do: request

  def fill_attachments(request, %{message: %{media: media, type: type} = message}) when not is_nil(media) do
    Inbox.Structs.UnifiedRequest.add_attachment(request, %{
      url: media,
      name: message[:file_name],
      type: if(type in ["picture", "sticker"], do: "image", else: "file")
    })
  end

  def fill_attachments(request, _), do: request
end
