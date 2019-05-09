defmodule OutboxEvent do
  require Logger
  use Gateway.Schema.Base
  defenum StatusEnum, new: 0, sent: 1, failed: 2

  schema "outbox_events" do
    belongs_to :device, Device
    field :external_id, :string
    field :data, :map
    field :meta, :string
    field :chat_ids, {:array, :string}
    field :status, StatusEnum

    timestamps()
  end

  def changeset(struct, %{external_id: external_id} = params) when is_number(external_id) do
    changeset(struct, params ||| %{external_id: Ext.Utils.Base.to_str(params[:external_id])})
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:external_id, :data, :status, :device_id, :chat_ids, :meta])
  end
end
