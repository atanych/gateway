defmodule Inbox.SaveContact do
  use BaseCommand

  def call({context, %{contact: contact, transport: transport} = request}) when not is_nil(contact) do
    request = %{request | contact: Inbox.UploadAvatar.call({context, contact}, transport)}
    {context, request}
  end

  def call(args), do: args
end
