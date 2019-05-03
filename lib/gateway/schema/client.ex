defmodule Client do
  require Logger
  use Gateway.Schema.Base

  schema "clients" do
    field(:nickname, :string)
    field(:avatar, :string)
    field(:uniq_key, :string)
    field(:external_id, :string)
    field(:lang, :string)
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    params = params ||| %{external_id: Ext.Utils.Base.to_str(params[:external_id])}

    struct |> cast(params, [:nickname, :avatar, :uniq_key, :lang, :external_id])
  end
end
