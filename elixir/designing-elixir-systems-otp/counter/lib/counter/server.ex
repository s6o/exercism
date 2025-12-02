defmodule Counter.Server do
  def run(count) do
    new_count = listen(count)
    run(new_count)
  end

  defp listen(count) do
    receive do
      {:tick, _pid} ->
        Counter.Core.increment(count)

      {:state, pid} ->
        send(pid, {:count, count})
    end
  end
end
