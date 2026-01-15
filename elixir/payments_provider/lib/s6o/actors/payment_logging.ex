defmodule S6o.Actors.PaymentLogging do
  @moduledoc """
  Collect payment request processing logs.

  The logging is not part of the `S6o.Actors.PaymentProcessing` by design to avoid
  loosing (in memory) logs when the payment processor is restarted by its supervisor.
  """
  @behaviour S6o.PaymentLogger
  @type payment_statistics_t :: %{logs: :ets.tid()}
  use GenServer

  @impl S6o.PaymentLogger
  @spec entries() :: list(S6o.PaymentLogger.entry_t())
  def entries() do
    GenServer.call(__MODULE__, :entries)
  end

  @impl S6o.PaymentLogger
  @spec log({:ok, S6o.PaymentRequest.t()} | S6o.PaymentRequest.t()) :: :ok
  def log({:ok, %S6o.PaymentRequest{} = pr}), do: log(pr)

  def log(%S6o.PaymentRequest{} = pr) do
    GenServer.cast(__MODULE__, {:payment_request, pr})
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  ### Impl-s ###################################################################

  @impl true
  @spec init(any) :: {:ok, payment_statistics_t()}
  def init(_arg) do
    table = :ets.new(:logs, [:set, :protected])
    initial_state = %{logs: table}

    {:ok, initial_state}
  end

  @impl true
  def handle_call(:entries, _from, state) do
    entries = :ets.tab2list(state.logs)
    {:reply, entries, state}
  end

  @impl true
  def handle_cast({:payment_request, %S6o.PaymentRequest{id: id} = pr}, state) do
    :ets.insert(state.logs, {id, pr})
    {:noreply, state}
  end
end
