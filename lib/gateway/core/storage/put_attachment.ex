defmodule Storage.PutAttachment do
  use BaseCommand

  def call(%{url: url} = attachment, type, company_id) do
    {:ok, %{"path" => path}} =
      Sdk.Storage.Client.upload(%Ext.Sdk.Request{
        payload: %{url: url, type: type, name: Map.get(attachment, :name), company_id: company_id}
      })

    path
  end
end
