defmodule InboxEvent do
  require Logger
  use Gateway.Schema.Base
  defenum StatusEnum, new: 0, sent: 1, failed: 2
  defenum TypeEnum, send_inbox: 0, update_inbox: 1, confirm_hook: 2

  schema "inbox_events" do
    belongs_to :device, Device
    belongs_to :client, Client
    field :external_id, :string
    field :data, :map
    field :status, StatusEnum
    field :type, TypeEnum

    timestamps()
  end

  def changeset(struct, params \\ %{})

  def changeset(struct, %{external_id: external_id} = params) when is_number(external_id) do
    changeset(struct, params ||| %{external_id: Ext.Utils.Base.to_str(params[:external_id])})
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:external_id, :data, :status, :type, :device_id, :client_id])
  end
end
