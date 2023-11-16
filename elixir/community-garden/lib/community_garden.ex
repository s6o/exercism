# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @spec start(Keyword.t()) :: Agent.on_start()
  def start(opts \\ []) do
    Agent.start(fn -> {1, []} end, opts)
  end

  @spec list_registrations(pid()) :: [Plot]
  def list_registrations(pid) do
    Agent.get(pid, fn {_, plots} -> plots end)
  end

  @spec register(pid(), String.t()) :: Plot
  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {next_id, plots} ->
      new_plot = %Plot{plot_id: next_id, registered_to: register_to}

      {new_plot, {next_id + 1, [new_plot | plots]}}
    end)
  end

  @spec release(pid(), pos_integer()) :: :ok
  def release(pid, plot_id) do
    Agent.update(pid, fn {next_id, plots} ->
      {next_id, Enum.reject(plots, fn p -> p.plot_id == plot_id end)}
    end)
  end

  @spec get_registration(pid(), pos_integer()) :: Plot | {:not_found, String.t()}
  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {_, plots} ->
      Enum.find(plots, {:not_found, "plot is unregistered"}, fn p -> p.plot_id == plot_id end)
    end)
  end
end
