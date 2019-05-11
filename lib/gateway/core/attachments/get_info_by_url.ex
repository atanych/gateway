defmodule Attachments.GetInfoByUrl do
  use BaseCommand

  def call(url) do
    %{headers: headers} = HTTPoison.head!(url)
    headers = Enum.into(headers, %{})

    %{
      length: headers["Content-Length"],
      mime_type: headers["Content-Type"],
      ext: MIME.extensions(headers["Content-Type"]) |> List.first()
    }
  end
end
