defmodule GatewayWeb.Router do
  use GatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Plugs.Params
  end

  scope "/" do
    pipe_through :api
    post "/webhooks/inbox/:transport", WebhooksController, :inbox
    post "/webhooks/outbox", WebhooksController, :outbox
  end
end
