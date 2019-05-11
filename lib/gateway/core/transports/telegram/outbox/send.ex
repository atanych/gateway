defmodule Transports.Telegram.Outbox.Send do
  use BaseCommand

  def call(%{device: %{settings: %{"token" => token}}}, packages) do
    Enum.map(packages, fn {method, payload} ->
      request = %Ext.Sdk.Request{payload: payload, options: %{url_params: token}}

      apply(Sdk.Telegram.Client, method, [request])
    end)
  end
end
