defmodule Outbox.Structs.Context do
  defstruct transport: nil, device: nil, events: []

  @supported_broadcast ["viber_public"]

  def init(params) do
    device = get_device(params)

    %__MODULE__{
      device: device,
      transport: Ext.Utils.Base.to_str(device.transport)
    }
    |> insert_events(params)
  end

  def get_device(%{device_id: device_id}) do
    case Device |> Gateway.Repo.get_by(id: device_id) do
      nil -> raise "Device is not found: device_id=#{device_id}}"
      device -> device
    end
  end

  def insert_events(%{transport: transport, device: device} = context, params) when transport in @supported_broadcast do
    event =
      %OutboxEvent{}
      |> Gateway.Repo.save!(%{
        device_id: device.id,
        data: params,
        chat_ids: params.chat_ids,
        external_id: params.event.id
      })

    %{context | events: [event]}
  end

  def insert_events(%{device: device} = context, params) do
    datetime = DateTime.utc_now()

    events =
      Enum.map(params.chat_ids, fn chat_id ->
        %{
          device_id: device.id,
          data: params,
          chat_ids: [chat_id],
          external_id: params.event.id,
          inserted_at: datetime,
          updated_at: datetime
        }
      end)

    {_, events} = Gateway.Repo.insert_all(OutboxEvent, events, returning: true)
    %{context | events: events}
  end
end
