defmodule Inbox.SaveClient do
  use BaseCommand

  def call({%{client: nil} = context, request}) do
    # fetch avatar
    client =
      Gateway.Repo.save!(%Client{}, %{
        lang: request.client.lang,
        nickname: request.client.nickname,
        uniq_key: request.client.uniq_key,
        external_id: request.client.id,
        avatar: get_avatar({context, request})
      })

    {%{context | client: client}, put_avatar(request, client.avatar)}
  end

  def call({%{client: client} = context, request}) do
    request = put_avatar(request, client.avatar)
    {context, request}
  end

  def get_avatar({%{device: device} = context, %{transport: transport} = request}) do
    url =
      case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.GetAvatar") do
        # should be implemented
        nil -> nil
        module -> module.call({context, request})
      end

    {:ok, %{"path" => path}} =
      Sdk.Storage.Client.upload(%Ext.Sdk.Request{payload: %{url: url, type: "avatar", company_id: device.company_id}})

    path
  end

  def put_avatar(request, avatar) do
    %{request | client: %{request.client | avatar: avatar}}
  end
end
