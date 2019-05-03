defmodule Gateway.Repo do
  use Ecto.Repo,
    otp_app: :gateway,
    adapter: Ecto.Adapters.Postgres

  use Ext.Ecto.Repo
end
