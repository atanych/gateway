defmodule Gateway.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"pgcrypto\";")

    create table(:clients, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:nickname, :string)
      add(:avatar, :string)
      add(:lang, :string)
      add(:uniq_key, :string)
      add(:external_id, :string)

      timestamps(type: :timestamptz)
    end

    create(unique_index(:clients, [:uniq_key]))
  end
end
