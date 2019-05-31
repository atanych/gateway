defmodule Gateway.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:company_id, :string)
      add(:uniq_key, :string)
      add(:settings, :map, default: %{})
      add(:transport, :smallint)

      timestamps(type: :timestamptz)
    end

    create(unique_index(:devices, [:uniq_key, :transport]))
  end
end
