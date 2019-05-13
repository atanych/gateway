defmodule Gql.Schema do
  @moduledoc false
  use Absinthe.Schema
  require IEx

  import_types(Gql.Types)

  query do
    field :current_time, :datetime do
      resolve fn _args, _context -> {:ok, Timex.now()} end
    end
  end

  mutation do
    import_fields(:outbox_event_mutations)
  end
end
