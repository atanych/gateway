defmodule Transports.ViberPublic.Subscribe do
  use BaseCommand

  def call(device) do
    case set_webhook(device) do
      {:ok, _} -> {:ok, fill_device_info(device)}
      {:error, message} -> {:error, message}
    end
  end

  def set_webhook(%{uniq_key: uniq_key, settings: %{"token" => token}}) do
    request = %Ext.Sdk.Request{
      payload: %{url: "#{System.get_env()["ROOT_URL"]}/webhooks/inbox/viber_public/#{uniq_key}"},
      headers: ["X-Viber-Auth-Token": token]
    }

    Sdk.ViberPublic.Client.set_webhook(request)
  end

  def fill_device_info(%{settings: %{"token" => token} = settings} = device) do
    request = %Ext.Sdk.Request{headers: ["X-Viber-Auth-Token": token]}

    {:ok, %{"name" => name, "uri" => uri}} = Sdk.ViberPublic.Client.get_account_info(request)
    settings = settings ||| %{"name" => name, "url" => "viber://pa?chatURI=#{uri}"}
    %{device | settings: settings}
  end
end
