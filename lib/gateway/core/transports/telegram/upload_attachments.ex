defmodule Transports.Telegram.UploadAttachments do
  use BaseCommand

  def call({%{device: %{settings: %{"token" => token}}} = context, %{message: %{attachments: [file_id]}} = request}) do
    attachments = [Sdk.Telegram.Client.get_file_path_by_id(file_id, token)]
    {context, %{request | message: %{request.message | attachments: attachments}}}
  end

  def call(args), do: args
end
