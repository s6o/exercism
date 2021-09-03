defmodule SqlParser do
  def run() do
    input = "select foo from bar"
    IO.puts("input: #{inspect(input)}\n")
    parse(input)
  end

  defp parse(input) do
    char(input)
  end

  defp char(input) do
    case input do
      "" -> {:error, "unexpected end of input"}
      <<char::utf8, rest::binary>> -> {:ok, char, rest}
    end
  end
end
