defmodule Outbox.Process do
  use BaseCommand

  def call(params) do
    params
    |> Outbox.Structs.Context.init()
    |> Outbox.Structs.Request.init(params[:event])
    |> Outbox.Send.call()
  end
end
