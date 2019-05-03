defmodule BaseCommand do
  @moduledoc """
  Every command should use this module and implement function `call`
  """

  defmacro __using__(_) do
    quote do
      require Logger
      require IEx
      import Ext.Utils.Map
    end
  end
end
