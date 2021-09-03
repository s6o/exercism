defmodule SqlParser do
  def run() do
    input = "1_foo bar_2"
    IO.puts("input: #{inspect(input)}\n")
    parse(input)
  end

  defp parse(input) do
    parser = choice([ascii_letter(), char(?_), digit()])
    parser.(input)
  end

  defp choice(parsers) do
    fn input ->
      case parsers do
        [] ->
          {:error, "no parsers succeeded"}

        [first_parser | other_parsers] ->
          with {:error, _reason} <- first_parser.(input) do
            choice(other_parsers).(input)
          end
      end
    end
  end

  defp digit(), do: satisfy(char(), fn char -> char in ?0..?9 end)
  defp ascii_letter(), do: satisfy(char(), fn char -> char in ?A..?Z or char in ?a..?z end)
  defp char(expected), do: satisfy(char(), fn char -> char == expected end)

  defp satisfy(parser, acceptor) do
    fn input ->
      with {:ok, term, rest} <- parser.(input) do
        if acceptor.(term) do
          {:ok, term, rest}
        else
          {:error, "term rejected"}
        end
      end
    end
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
