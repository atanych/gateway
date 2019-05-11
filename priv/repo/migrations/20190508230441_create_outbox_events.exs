defmodule Gateway.Repo.Migrations.CreateOutboxEvents do
  use Ecto.Migration

  def change do
    create table(:outbox_events, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:device_id, references(:devices, type: :uuid, on_delete: :delete_all))
      add(:data, :map)
      add(:chat_ids, :map)
      add(:external_id, :string)
      add(:meta, :text)
      add(:status, :smallint, default: 0)

      timestamps(type: :timestamptz)
    end
  end
end
