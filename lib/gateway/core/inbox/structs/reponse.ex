defmodule Inbox.Structs.Response do
  defstruct format: :json, status: 200, body: %{status: :ok}, type: :success
end
