defmodule Sdk.Vadesk.Client do
  use Ext.Sdk.BaseClient, endpoints: Map.keys(Sdk.Vadesk.Config.data().endpoints)
  require IEx
  require Logger
end
