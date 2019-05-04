defmodule Sdk.Storage.Client do
  use Ext.Sdk.BaseClient, endpoints: Map.keys(Sdk.Storage.Config.data().endpoints)
  require IEx
  require Logger
end
