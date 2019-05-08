defmodule Sdk.ViberPublic.Client do
  # https://developers.viber.com/docs/api/rest-bot-api/#webhooks
  use Ext.Sdk.BaseClient, endpoints: Map.keys(Sdk.ViberPublic.Config.data().endpoints)
  require IEx
  require Logger
end
