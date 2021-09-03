defmodule SqlParser do
  def run() do
    input = "foo_1, bar_2 col4"
    IO.puts("input: #{inspect(input)}\n")
    parse(input)
  end

  defp parse(input) do
    parser = columns()
    parser.(input)
  end

  defp columns(), do: separated_list(token(identifier()), token(char(?,)))

  defp separated_list(element_parser, separator_parser) do
    sequence([
      element_parser,
      many(sequence([separator_parser, element_parser]))
    ])
    |> map(fn [first_element, rest] ->
      other_elements = Enum.map(rest, fn [_, element] -> element end)
      [first_element | other_elements]
    end)
  end

  defp token(parser) do
    sequence([
      many(choice([char(?\s), char(?\n)])),
      parser,
      many(choice([char(?\s), char(?\n)]))
    ])
    |> map(fn [_lw, term, _tw] -> term end)
  end

  defp sequence(parsers) do
    fn input ->
      case parsers do
        [] ->
          {:ok, [], input}

        [first_parser | other_parsers] ->
          with {:ok, first_term, rest} <- first_parser.(input),
               {:ok, other_terms, rest} <- sequence(other_parsers).(rest) do
            {:ok, [first_term | other_terms], rest}
          end
      end
    end
  end

  defp map(parser, mapper) do
    fn input ->
      with {:ok, term, rest} <- parser.(input) do
        {:ok, mapper.(term), rest}
      end
    end
  end

  defp identifier() do
    many(identifier_char())
    |> satisfy(fn chars -> chars != [] end)
    |> map(fn chars -> to_string(chars) end)
  end

  defp many(parser) do
    fn input ->
      case parser.(input) do
        {:error, _reason} ->
          {:ok, [], input}

        {:ok, first_term, rest} ->
          {:ok, other_terms, rest} = many(parser).(rest)
          {:ok, [first_term | other_terms], rest}
      end
    end
  end

  defp identifier_char(), do: choice([ascii_letter(), char(?_), digit()])

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
