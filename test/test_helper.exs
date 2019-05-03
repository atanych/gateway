ExUnit.start(capture_log: true)
{:ok, _} = Application.ensure_all_started(:ex_machina)
Ecto.Adapters.SQL.Sandbox.mode(Gateway.Repo, {:shared, self()})
