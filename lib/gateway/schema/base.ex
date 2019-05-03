defmodule Gateway.Schema.Base do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      require IEx
      import Ext.Utils.Map
      import Ecto.{Changeset, Query}
      import EctoEnum, only: [defenum: 2]
      @type t :: %__MODULE__{}
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
