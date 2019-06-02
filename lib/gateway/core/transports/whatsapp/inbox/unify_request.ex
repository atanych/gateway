defmodule Transports.Whatsapp.Inbox.UnifyRequest do
  use BaseCommand

  # def call(%{edited_message: edited_message} = params) when not is_nil(edited_message),
  #   do: call(params ||| %{message: edited_message, edited_message: nil})

  def call(%{messages: _messages, transport: _transport} = params) do
    message = List.first(params.messages)

    params
    |> init_request()
    |> fill_attachments(message)
    |> fill_contact(message)
    |> fill_location(message)
  end

  def init_request(%{messages: messages, transport: transport}) do
    message = List.first(messages)

    Inbox.Structs.UnifiedRequest.init(%{
      chat: %{
        id: Ext.Utils.Base.to_str(message[:chat_id]),
        title: message[:chat_name],
        type: (message.chat_id =~ "@g" && "group") || "private"
      },
      client: %{
        id: message[:author],
        uniq_key: "#{transport}/#{message[:author]}",
        nickname: message[:sender_name],
        lang: "en"
      },
      message: %{
        id: message[:id],
        text: message[:body] || message[:caption],
        location: "en"
      },
      event_type: "send_inbox"
    })
  end

  def fill_location(request, message) do
    case message.type do
      "location" ->
        lat_lon = String.split(message.body, ";")
        %{request | message: %{request.message | location: %{lat: List.first(lat_lon), lon: List.last(lat_lon)}}}

      _ ->
        request
    end
  end

  def fill_contact(request, message) do
    cond do
      message.type == "vcard" ->
        Inbox.Structs.UnifiedRequest.add_contact(request, %{
          id: List.last(Regex.run(~r"waid=(.*)\:", message.body)),
          nickname: List.last(Regex.run(~r"FN:(.*)\nit", message.body)),
          phone: List.last(Regex.run(~r"waid=(.*)\:", message.body))
        })

      true ->
        request
    end
  end

  # Enum = ["chat", "image", "ptt", "document", "audio", "video", "location", "call_log"]
  # ptt - voice message
  def fill_attachments(request, message) do
    cond do
      message.type in ["image", "document", "audio", "video", "ptt"] ->
        Inbox.Structs.UnifiedRequest.add_attachment(
          request,
          %{
            url: message.body,
            name: List.last(Regex.run(~r".*/([^/]+)\?[^\.]+$", message.body)),
            type: if(message.type == "image", do: "image", else: "file")
          }
        )

      true ->
        request
    end
  end
end
