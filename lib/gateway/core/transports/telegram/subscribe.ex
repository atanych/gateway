defmodule Transports.Telegram.Subscribe do
  use BaseCommand

  def call(device) do
    case set_webhook(device) do
      {:ok, _} -> {:ok, fill_device_info(device)}
      {:error, message} -> {:error, message}
    end
  end

  def set_webhook(%{uniq_key: uniq_key, settings: %{"token" => token}}) do
    request = %Ext.Sdk.Request{
      payload: %{url: "#{System.get_env()["ROOT_URL"]}/webhooks/inbox/telegram/#{uniq_key}"},
      options: %{url_params: token}
    }

    Sdk.Telegram.Client.set_webhook(request)
  end

  def fill_device_info(%{settings: %{"token" => token} = settings} = device) do
    request = %Ext.Sdk.Request{options: %{url_params: token}}

    {:ok, %{"result" => %{"username" => username}}} = Sdk.Telegram.Client.get_me(request)
    settings = settings ||| %{"name" => username, "url" => "https://t.me/#{username}"}
    %{device | settings: settings}
  end
end
