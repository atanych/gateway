defmodule Inbox.UploadAttachments do
  use BaseCommand

  def call({context, %{message: %{attachments: []}} = request}), do: {context, request}

  def call({context, request}) do
    {context, %{message: %{attachments: attachments}}} = prepare({context, request})
    attachments = Enum.map(attachments, fn attachment -> put(context, attachment) end)
    {context, %{request | message: %{request.message | attachments: attachments}}}
  end

  def prepare({context, %{transport: transport} = request}) do
    case Ext.Utils.Base.to_existing_atom("Elixir.Transports.#{Macro.camelize(transport)}.UploadAttachments") do
      nil -> {context, request}
      module -> module.call({context, request})
    end
  end

  def put(%{device: %{company_id: company_id}}, attachment) do
    uploader_type = if attachment.type == "image", do: "message_image", else: "message_file"
    %{attachment | path: Storage.PutAttachment.call(attachment, uploader_type, company_id)}
  end
end
