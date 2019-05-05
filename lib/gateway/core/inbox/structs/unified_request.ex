defmodule(Inbox.Structs.UnifiedRequest.Chat, do: defstruct(id: nil, title: nil, type: "private"))

defmodule(Inbox.Structs.UnifiedRequest.Client,
  do: defstruct(id: nil, uniq_key: nil, nickname: nil, avatar: nil, lang: nil)
)

defmodule(Inbox.Structs.UnifiedRequest.Message, do: defstruct(id: nil, text: nil, attachments: [], location: nil))

defmodule Inbox.Structs.UnifiedRequest.Attachment do
  @derive {Jason.Encoder, only: [:name, :path, :size, :mime_type, :width, :height, :duration]}
  defstruct(
    name: nil,
    path: nil,
    url: nil,
    id: nil,
    size: nil,
    mime_type: nil,
    width: nil,
    height: nil,
    type: "image",
    duration: nil
  )
end

defmodule Inbox.Structs.UnifiedRequest do
  defstruct chat: %Inbox.Structs.UnifiedRequest.Chat{},
            client: %Inbox.Structs.UnifiedRequest.Client{},
            message: %Inbox.Structs.UnifiedRequest.Message{},
            event_type: nil,
            attachments: [],
            transport: nil,
            device_uniq_key: nil

  def init(%{chat: chat, client: client, message: message} = params) do
    struct(__MODULE__, %{
      params
      | chat: struct(Inbox.Structs.UnifiedRequest.Chat, chat),
        message: struct(Inbox.Structs.UnifiedRequest.Message, message),
        client: struct(Inbox.Structs.UnifiedRequest.Client, client)
    })
  end

  def add_attachment(request, attachment) do
    %{
      request
      | message: %{
          request.message
          | attachments: request.attachments ++ [struct(Inbox.Structs.UnifiedRequest.Attachment, attachment)]
        }
    }
  end
end
