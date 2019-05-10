defmodule Attachments.GetFileTypeByPath do
  use BaseCommand

  @types %{
    "avi" => :video,
    "mp4" => :video,
    "pdf" => :file,
    "png" => :image,
    "jpg" => :image,
    "jpeg" => :image,
    "gif" => :image,
    "webp" => :image,
    "mp3" => :audio
  }

  def call(path) do
    [path | _] = String.split(path, "?")

    ext =
      case Path.extname(path) |> String.downcase() do
        "." <> ext -> ext
        _ -> ""
      end

    Map.get(@types, ext, :file)
  end
end
