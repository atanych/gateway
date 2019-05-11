defmodule Transports.ViberPublic.Outbox.Send do
  use BaseCommand

  def call(%{device: %{settings: %{"token" => token}}}, packages) do
    Enum.map(packages, fn {method, payload} ->
      request = %Ext.Sdk.Request{payload: payload, headers: ["X-Viber-Auth-Token": token]}

      case apply(Sdk.ViberPublic.Client, method, [request]) do
        {:ok, %{"status" => 0} = response} -> {:ok, response}
        {_, response} -> {:error, response}
      end
    end)
  end
end
