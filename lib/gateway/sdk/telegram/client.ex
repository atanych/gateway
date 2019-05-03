defmodule Sdk.Telegram.Client do
  use Ext.Sdk.BaseClient, endpoints: Map.keys(Sdk.Telegram.Config.data().endpoints)
  require IEx
  require Logger
end
