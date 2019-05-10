defmodule Factories.Gateway.Base do
  use ExMachina.Ecto, repo: Gateway.Repo
  use Factories.Gateway.Device
  use Factories.Gateway.Client
  use Factories.Gateway.OutboxEvent
end
