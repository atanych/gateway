defmodule Inbox.Process do
  use BaseCommand

  def call(%{transport: _transport} = request) do
    if Inbox.IsValidRequest.call(request) do
      request
      |> Inbox.UnifyRequest.call()
      |> Inbox.Structs.Context.init()
      |> Inbox.UploadAttachments.call()
      |> Inbox.SaveClient.call()
      |> Inbox.SaveContact.call()
      |> Inbox.PerformEvent.call()
      |> Inbox.SaveEvent.call()
      |> Inbox.BroadcastToVadesk.call()
      |> Inbox.PrepareResponse.call()
    else
      %Inbox.Structs.Response{body: %{status: :invalid_request}, type: :error}
    end
  end
end
