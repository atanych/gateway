defmodule Gateway.Repo.Migrations.CreateInboxEvents do
  use Ecto.Migration

  def change do
    create table(:inbox_events, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:client_id, references(:clients, type: :uuid, on_delete: :delete_all))
      add(:device_id, references(:devices, type: :uuid, on_delete: :delete_all))
      add(:text, :text)
      add(:location, :map)
      add(:external_id, :string)
      add(:extra, :map, default: %{})
      add(:attachments, :map)
      add(:status, :smallint, default: 0)
      add(:type, :smallint, null: false)

      timestamps(type: :timestamptz)
    end
  end
end
