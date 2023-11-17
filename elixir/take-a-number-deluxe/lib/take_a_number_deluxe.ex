defmodule TakeANumberDeluxe do
  use GenServer
  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:next_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset)
  end

  # Server callbacks

  @impl GenServer
  def init(init_arg) do
    min_num = Keyword.get(init_arg, :min_number)
    max_num = Keyword.get(init_arg, :max_number)
    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)

    with {:ok, state} <- TakeANumberDeluxe.State.new(min_num, max_num, auto_shutdown_timeout) do
      {:ok, state, auto_shutdown_timeout}
    else
      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_number, _from, state) do
    with {:ok, num, new_state} <- TakeANumberDeluxe.State.queue_new_number(state) do
      {:reply, {:ok, num}, new_state, new_state.auto_shutdown_timeout}
    else
      {:error, _reason} = e ->
        {:reply, e, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:next_number, priority_number}, _from, state) do
    with {:ok, num, new_state} <-
           TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:reply, {:ok, num}, new_state, new_state.auto_shutdown_timeout}
    else
      {:error, _reason} = e ->
        {:reply, e, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset, state) do
    {:ok, new_state, timeout} =
      Map.from_struct(state)
      |> Map.delete(:queue)
      |> Map.to_list()
      |> init()

    {:noreply, new_state, timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state}

  def handle_info(_msg, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
