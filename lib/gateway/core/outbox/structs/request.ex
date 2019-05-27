defmodule Outbox.Structs.Attachment do
  defstruct url: nil, name: nil
end

defmodule Outbox.Structs.Request do
  @derive Jason.Encoder
  defstruct id: nil, text: nil, attachments: [], extra: nil
  require IEx

  def init(%{transport: _transport} = context, params) do
    struct = struct(__MODULE__, params)

    attachments =
      Enum.map(params[:attachments] || [], fn attachment -> struct(Outbox.Structs.Attachment, attachment) end)

    {context, %{struct | attachments: attachments, extra: Outbox.Structs.Extra.init(params[:extra] || %{})}}
  end
end
