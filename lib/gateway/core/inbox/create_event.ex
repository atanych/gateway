defmodule Inbox.CreateEvent do
  use BaseCommand

  def call({%{client: client, device: device} = context, request}) do
    event =
      Gateway.Repo.save!(%InboxEvent{}, %{
        location: request.message.location,
        text: request.message.text,
        attachments: request.message.attachments,
        device_id: device.id,
        client_id: client.id,
        extra: %{chat_id: request.chat.id, type: request.chat.type},
        external_id: request.message.id,
        type: request.event_type
      })

    {%{context | event: event}, request}
  end
end
