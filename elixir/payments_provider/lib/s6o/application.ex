defmodule S6o.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    children = [
      {S6o.Actors.PaymentLogging, nil},
      {S6o.Actors.PaymentProcessing,
       {S6o.ProviderRouting.route_table!(), S6o.Actors.PaymentLogging, 2}}
    ]

    opts = [strategy: :one_for_one, name: S6o.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
