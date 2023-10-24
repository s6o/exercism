defmodule TakeANumber do
  @spec start() :: pid()
  def start() do
    spawn(fn -> proc_loop(%{:number => 0}) end)
  end

  @spec proc_loop(state :: %{required(:number) => non_neg_integer()}) :: no_return
  defp proc_loop(state) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, state.number)
        proc_loop(state)

      {:take_a_number, sender_pid} ->
        new_state = Map.update!(state, :number, fn n -> n + 1 end)
        send(sender_pid, new_state.number)
        proc_loop(new_state)

      :stop ->
        :ok

      _ ->
        proc_loop(state)
    end
  end
end
