defmodule Transports.Telegram.Outbox.PreparePackages do
  use BaseCommand

  def call(request, [chat_id]) do
    collect([], request, chat_id)
  end

  def collect(packages, %{attachments: [], text: text, extra: %{keyboard: keyboard}}, chat_id) do
    packages ++ [{:send_message, fill_reply_markup(%{text: text, chat_id: chat_id}, keyboard)}]
  end

  def collect(packages, %{attachments: [attachment], text: text, extra: %{keyboard: keyboard}}, chat_id) do
    attachment_type = Attachments.GetFileTypeByPath.call(attachment)
    body_key = get_body_key_by_attachment_type(attachment_type)

    packages ++
      [
        {get_method_by_attachment_type(attachment_type),
         %{chat_id: chat_id}
         |> fill_reply_markup(keyboard)
         |> fill_caption(text)
         |> Map.merge(%{body_key => attachment})}
      ]
  end

  def collect(packages, %{attachments: [attachment | attachments]} = request, chat_id) do
    packages ++
      collect(packages, %{request | attachments: [attachment], text: nil, extra: %{keyboard: %{buttons: []}}}, chat_id) ++
      collect(packages, %{request | attachments: attachments}, chat_id)
  end

  def fill_caption(package, nil), do: package
  def fill_caption(package, caption), do: package ||| %{caption: caption}

  def fill_reply_markup(package, keyboard) do
    case Transports.Telegram.Outbox.PrepareReplyMarkup.call(keyboard) do
      nil -> package
      reply_markup -> package ||| %{reply_markup: reply_markup}
    end
  end

  def get_method_by_attachment_type(:image), do: :send_photo
  def get_method_by_attachment_type(:file), do: :send_document
  def get_method_by_attachment_type(:video), do: :send_video
  def get_method_by_attachment_type(:audio), do: :send_audio

  def get_body_key_by_attachment_type(:image), do: :photo
  def get_body_key_by_attachment_type(:file), do: :document
  def get_body_key_by_attachment_type(:video), do: :video
  def get_body_key_by_attachment_type(:audio), do: :audio
end
