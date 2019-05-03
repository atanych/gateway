defmodule Plugs.Params do
  @moduledoc false
  @behaviour Plug
  require IEx

  def init(opts), do: opts

  def call(conn, _) do
    %{conn | params: conn.params |> Ext.Utils.Base.to_atom()}
  end
end
