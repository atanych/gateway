defmodule InboxEvent do
  require Logger
  use Gateway.Schema.Base
  defenum StatusEnum, new: 0, sent: 1, failed: 2
  defenum TypeEnum, send_inbox: 0, update_inbox: 1, confirm_hook: 2

  schema "inbox_events" do
    belongs_to :device, Device
    belongs_to :client, Client
    field :text, :string
    field :external_id, :string
    field :extra, :map
    field :location, :map
    field :attachments, {:array, :string}
    field :status, StatusEnum
    field :type, TypeEnum

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    params = params ||| %{external_id: Ext.Utils.Base.to_str(params[:external_id])}

    struct
    |> cast(params, [:text, :external_id, :extra, :location, :attachments, :status, :type, :device_id, :client_id])
  end
end
