defmodule Gql.Types do
  @moduledoc false
  use Absinthe.Schema.Notation

  import_types(Ext.Gql.Types.Scalar.SnakeKeysJson)
  import_types(Ext.Gql.Types.Scalar.Json)
  import_types(Ext.Gql.Types.Scalar.DateTime)
  import_types(Ext.Gql.Types.Scalar.Date)
  import_types(Gql.Real.OutboxEvents.Mutation)
end
