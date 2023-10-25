defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.split(~r{[^\w\-']|_}u, trim: true)
    |> Enum.reduce(%{}, fn wd, accum ->
      w = String.downcase(wd) |> String.trim_leading("'") |> String.trim_trailing("'")

      case accum do
        %{^w => count} -> %{accum | w => count + 1}
        _ -> Map.put_new(accum, w, 1)
      end
    end)
  end
end
