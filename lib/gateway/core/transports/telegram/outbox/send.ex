defmodule Transports.Telegram.Outbox.Send do
  use BaseCommand

  def call({%{device: %{settings: %{"token" => token}}}, request}, [chat_id]) do
    packages = Transports.Telegram.Outbox.PreparePackages.call(request, chat_id)

    response =
      Enum.map(packages, fn {method, payload} ->
        request = %Ext.Sdk.Request{
          payload: payload,
          options: %{url_params: token}
        }

        apply(Sdk.Telegram.Client, method, [request])
      end)

    if(Enum.all?(response, fn {status, _} -> status == :ok end)) do
      {:ok, :nth}
    else
      {:error, response}
    end
  end
end
