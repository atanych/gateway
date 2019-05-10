defmodule WebhooksController do
  use GatewayWeb, :controller

  def inbox(conn, %{transport: transport} = params)
      when transport in ["telegram", "whatsapp", "facebook", "livechat", "wechat", "viber_public"] do
    %{format: format, body: body, status: status, type: type} = response = Inbox.Process.call(params)

    if type == :error, do: Logger.warn("Inbox request is not correct #{inspect(response)}.\n#{inspect(params)}")

    conn = Plug.Conn.put_status(conn, status)
    apply(Phoenix.Controller, format, [conn, body])
  end

  def outbox(conn, params) do
    Outbox.Process.call(params)
    json(conn, %{status: :ok})
  end
end
