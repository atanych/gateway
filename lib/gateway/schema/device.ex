defmodule Device do
  require Logger
  use Gateway.Schema.Base
  defenum StatusEnum, inactive: 0, active: 1

  defenum TransportEnum,
    sms: 1,
    whatsapp: 2,
    telegram: 4,
    viber_public: 11,
    ok: 12,
    insta_i2crm: 14,
    twitter: 16,
    skype: 17,
    vox_implant: 18,
    email: 19,
    wechat: 20

  schema "devices" do
    field(:transport, TransportEnum)
    field(:status, StatusEnum)
    field(:settings, :map)
    field(:company_id, :binary_id)
    field(:account_id, :binary_id)
    field(:uniq_key, :string)
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct |> cast(params, [:transport, :settings, :uniq_key])
  end
end
