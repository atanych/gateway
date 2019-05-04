defmodule Storage.PutAttachment do
  use BaseCommand

  def call(url, type, company_id) do
    {:ok, %{"path" => path}} =
      Sdk.Storage.Client.upload(%Ext.Sdk.Request{payload: %{url: url, type: type, company_id: company_id}})

    path
  end
end
