defmodule Transports.Telegram.UploadAttachments do
  use BaseCommand

  def call({%{device: %{settings: %{"token" => token}}} = context, %{message: %{attachments: [attachment]}} = request}) do
    attachment = %{attachment | url: Sdk.Telegram.Client.get_file_url_by_id(attachment.id, token)}
    {context, %{request | message: %{request.message | attachments: [attachment]}}}
  end

  def call(args), do: args
end
