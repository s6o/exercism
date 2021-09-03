defmodule SqlParser do
  def run() do
    input = "select foo from bar"
    IO.puts("input: #{inspect(input)}\n")
    parse(input)
  end

  defp parse(input) do
    parser = char()
    parser.(input)
  end

  defp char() do
    fn input ->
      case input do
        "" -> {:error, "unexpected end of input"}
        <<char::utf8, rest::binary>> -> {:ok, char, rest}
      end
    end
  end
end
