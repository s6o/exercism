defmodule SqlParser do
  def run() do
    input = "select foo from bar"
    IO.puts("input: #{inspect(input)}\n")
    parse(input)
  end

  defp parse(input) do
    nil
  end
end
