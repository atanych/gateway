defmodule Inbox.SaveClient do
  use BaseCommand

  def call({%{client: nil} = context, %{client: client, transport: transport} = request}) do
    request = %{request | client: Inbox.UploadAvatar.call({context, client}, transport)}
    # fetch avatar
    client =
      Gateway.Repo.save!(%Client{}, %{
        lang: client.lang,
        nickname: client.nickname,
        uniq_key: client.uniq_key,
        external_id: client.id,
        avatar: request.client.avatar
      })

    {%{context | client: client}, request}
  end

  def call({%{client: client} = context, request}) do
    request = %{request | client: %{request.client | avatar: client.avatar}}
    {context, request}
  end
end
