defmodule Transports.Telegram.Subscribe do
  use BaseCommand

  def call(%{device_id: device_id}) do
    %{uniq_key: uniq_key, settings: %{"token" => token}} = Device |> Gateway.Repo.get!(device_id)

    request = %Ext.Sdk.Request{
      payload: %{url: "#{System.get_env()["ROOT_URL"]}/webhooks/inbox/telegram/#{uniq_key}"},
      options: %{url_params: token}
    }

    Sdk.Telegram.Client.set_webhook(request)
  end
end
