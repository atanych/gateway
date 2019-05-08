defmodule Transports.ViberPublic.Subscribe do
  use BaseCommand

  def call(%{device_id: device_id}) do
    %{uniq_key: uniq_key, settings: %{"token" => token}} = Device |> Gateway.Repo.get!(device_id)

    request = %Ext.Sdk.Request{
      payload: %{
        url: "#{System.get_env()["ROOT_URL"]}/webhooks/inbox/viber_public/#{uniq_key}",
#        send_name: true,
#        send_photo: true
      },
      headers: ["X-Viber-Auth-Token": token]
    }

    Sdk.ViberPublic.Client.set_webhook(request)
  end
end
