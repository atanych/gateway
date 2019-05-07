defmodule Inbox.SaveEvent do
  use BaseCommand

  def call({%{client: client, device: device} = context, request}) do
    event =
      Gateway.Repo.save!(%InboxEvent{}, %{
        device_id: device.id,
        client_id: client.id,
        data: request,
        external_id: request.message.id,
        type: request.event_type
      })

    {%{context | event: event}, request}
  end
end
