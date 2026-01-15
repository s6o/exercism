defmodule S6o.Actors.PaymentProcessing do
  @moduledoc """
  Process payment requests via configured payment provider routing table and
  log payment processing attempts via configured logger.
  """
  use GenServer
  require Logger

  @spec process_payment(payment_request :: S6o.PaymentRequest.t()) ::
          {:error, any()} | {:ok, S6o.PaymentReceipt.t()}
  def process_payment(%S6o.PaymentRequest{} = pr) do
    GenServer.call(__MODULE__, {:process_payment, pr})
  end

  @spec start_link(
          {route_table :: S6o.ProviderRouting.routes_t(), logger :: S6o.PaymentLogger.t(),
           retry_max :: pos_integer()}
        ) ::
          :ignore | {:error, any} | {:ok, pid}
  def start_link(t) do
    GenServer.start_link(__MODULE__, t, name: __MODULE__)
  end

  ### Impl-s ###################################################################

  @impl true
  @spec init(
          {route_table :: S6o.ProviderRouting.routes_t(), logger :: S6o.PaymentLogger.t(),
           retry_max :: pos_integer()}
        ) ::
          {:ok, S6o.PaymentProcessor.t()}
  def init({route_table, logger, retry_max}) do
    {:ok, S6o.PaymentProcessor.new!(route_table, logger, retry_max)}
  end

  @impl true
  def handle_call({:process_payment, %S6o.PaymentRequest{} = pr}, _from, state) do
    {_, result} =
      S6o.PaymentProcessor.process_payment(pr, state)
      |> S6o.PaymentProcessor.retry_payment(state)

    {:reply, result, state}
  end

  @impl true
  def handle_info(_message, state) do
    Logger.warning("Unknown message received.")
    {:noreply, state}
  end
end
