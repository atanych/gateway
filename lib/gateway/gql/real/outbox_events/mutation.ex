defmodule Gql.Real.OutboxEvents.Mutation do
  use Absinthe.Schema.Notation

  input_object :outbox_attachment_params do
    field :url, :string
    field :name, :string
  end

  input_object :outbox_extra_params do
    field :keyboard, :outbox_keyboard_params
    field :name, :string
  end

  input_object :outbox_keyboard_params do
    field :buttons, list_of(:outbox_keyboard_buttons_params)
  end

  input_object :outbox_keyboard_buttons_params do
    field :text, :string
  end

  input_object :outbox_event_params do
    field :id, non_null(:string)
    field :text, :string
    field :extra, :outbox_extra_params
    field :attachments, list_of(:outbox_attachment_params)
  end

  object :outbox_event_mutations do
    @desc "Send outbox"
    field :send_outbox_event, type: :string do
      arg :chat_ids, non_null(list_of(:string))
      arg :device_id, non_null(:string)
      arg :event, non_null(:outbox_event_params)
      resolve &Gql.Real.OutboxEvents.Resolver.send/2
    end
  end
end
