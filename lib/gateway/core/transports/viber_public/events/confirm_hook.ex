defmodule Transports.ViberPublic.Events.ConfirmHook do
  use BaseCommand

  def call({context, %{transport: transport} = params}) do
    {%{context | response: %Inbox.Structs.Response{body: %{status: :ok}}}, params}
  end
end