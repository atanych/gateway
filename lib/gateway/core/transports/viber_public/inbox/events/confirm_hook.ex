defmodule Transports.ViberPublic.Inbox.Events.ConfirmHook do
  use BaseCommand

  def call({context, %{transport: _transport} = params}) do
    {%{context | response: %Inbox.Structs.Response{body: %{status: :ok}}}, params}
  end
end
