defmodule Transports.ViberPublic.Outbox.PreparePackages do
  use BaseCommand

  def call(request, chat_ids) do
    collect([], request, chat_ids)
  end

  def collect(packages, %{attachments: [], text: text, extra: %{keyboard: keyboard}}, chat_ids) do
    package =
      %{text: text, type: "text"}
      |> fill_keyboard(keyboard)
      |> fill_chat_ids(chat_ids)

    packages ++ [{get_method_by_chat_ids(chat_ids), package}]
  end

  def collect(packages, %{attachments: [attachment | attachments]} = request, chat_ids) do
    attachment_type = Attachments.GetFileTypeByPath.call(attachment)

    package =
      %{type: get_type_by_attachment_type(attachment_type), media: attachment}
      |> fill_chat_ids(chat_ids)

    packages ++
      [{get_method_by_chat_ids(chat_ids), package}] ++
      collect(packages, %{request | attachments: attachments}, chat_ids)
  end

  def fill_chat_ids(package, [chat_ids]), do: package ||| %{receiver: chat_ids}
  def fill_chat_ids(package, chat_ids), do: package ||| %{broadcast_list: chat_ids}
  def fill_caption(package, nil), do: package
  def fill_caption(package, caption), do: package ||| %{caption: caption}

  def fill_keyboard(package, keyboard) do
    case Transports.ViberPublic.Outbox.PrepareKeyboard.call(keyboard) do
      nil -> package
      keyboard -> package ||| %{keyboard: keyboard}
    end
  end

  def get_method_by_chat_ids([_chat_id]), do: :send_message
  def get_method_by_chat_ids(_), do: :broadcast_message

  def get_type_by_attachment_type(:image), do: "picture"
  def get_type_by_attachment_type(:file), do: "file"
  def get_type_by_attachment_type(:video), do: "video"
  def get_type_by_attachment_type(_), do: "file"
end
