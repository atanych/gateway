defmodule Gql.Devices.Mutation do
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

  object :device_mutations do
    @desc "Connect device"
    field :connect_device, type: :device do
      arg :id, non_null(:uuid)
      resolve &Gql.Devices.Resolver.connect/2
    end
  end
end
