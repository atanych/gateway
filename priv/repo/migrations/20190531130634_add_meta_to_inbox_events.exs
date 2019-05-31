defmodule Gateway.Repo.Migrations.AddMetaToInboxEvents do
  use Ecto.Migration

  def change do
    alter table(:inbox_events) do
      add(:meta, :text)
    end
  end
end
