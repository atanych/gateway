defmodule Gateway.Repo.Migrations.AddAccountIdToDevice do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      remove(:company_id)
      add(:account_id, :uuid)
      add(:company_id, :uuid)
      add(:status, :smallint, default: 1)
    end
  end
end
