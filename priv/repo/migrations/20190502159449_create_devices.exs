defmodule Gateway.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:uniq_key, :string)
      add(:settings, :map, default: %{})
      add(:transport, :smallint)

      timestamps(type: :timestamptz)
    end

    create(unique_index(:devices, [:transport, :uniq_key]))
  end
end
