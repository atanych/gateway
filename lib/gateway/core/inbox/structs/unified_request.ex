defmodule Inbox.Structs.UnifiedRequest.Chat do
  @derive Jason.Encoder

  defstruct(id: nil, title: nil, type: "private")
end

defmodule Inbox.Structs.UnifiedRequest.Client do
  @derive Jason.Encoder
  defstruct(id: nil, uniq_key: nil, nickname: nil, avatar: nil, lang: nil, country: nil, phone: nil)
end

defmodule Inbox.Structs.UnifiedRequest.Message do
  @derive Jason.Encoder
  defstruct(id: nil, text: nil, attachments: [], location: nil)
end

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
  @derive Jason.Encoder
  defstruct chat: %Inbox.Structs.UnifiedRequest.Chat{},
            client: %Inbox.Structs.UnifiedRequest.Client{},
            message: %Inbox.Structs.UnifiedRequest.Message{},
            event_type: nil,
            transport: nil,
            device_uniq_key: nil,
            reply: nil,
            contact: nil

  import Ext.Utils.Map

  def init(params) do
    struct(
      __MODULE__,
      params |||
        %{
          chat: struct(Inbox.Structs.UnifiedRequest.Chat, params[:chat] || %{}),
          message: struct(Inbox.Structs.UnifiedRequest.Message, params[:message] || %{}),
          client: struct(Inbox.Structs.UnifiedRequest.Client, params[:client] || %{})
        }
    )
  end

  def add_attachment(request, attachment) do
    %{
      request
      | message: %{
          request.message
          | attachments: request.message.attachments ++ [struct(Inbox.Structs.UnifiedRequest.Attachment, attachment)]
        }
    }
  end

  def add_contact(request, contact) do
    %{request | contact: struct(Inbox.Structs.UnifiedRequest.Client, contact)}
  end
end
