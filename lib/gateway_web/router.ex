defmodule GatewayWeb.Router do
  use GatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Ext.Plugs.Params
  end

  pipeline :gql do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api
    post "/webhooks/inbox/:transport/:device_uniq_key", WebhooksController, :inbox
    post "/webhooks/inbox/:transport", WebhooksController, :inbox
  end

  scope "/" do
    pipe_through :gql
    forward "/api", Absinthe.Plug, schema: Gql.Schema, json_codec: Jason
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Gql.Schema, json_codec: Jason
end
