defmodule Bob do
  def hey(input) do
    cond do
      is_silence?(input) ->
        "Fine. Be that way!"

      is_yell?(input) && String.ends_with?(String.trim(input), ["?"]) == false ->
        "Whoa, chill out!"

      is_yell?(input) == false && String.ends_with?(String.trim(input), ["?"]) ->
        "Sure."

      is_yell?(input) && String.ends_with?(String.trim(input), ["?"]) ->
        "Calm down, I know what I'm doing!"

      true ->
        "Whatever."
    end
  end

  defp is_silence?(input) do
    input |> String.trim() |> String.length() == 0
  end

  defp is_yell?(input) do
    result =
      input
      |> String.split()
      |> Enum.filter(fn w -> String.match?(w, ~r/[^0-9]\w+/) end)
      |> Enum.map(fn w -> String.match?(w, ~r{\w+}) && String.upcase(w) == w end)

    Enum.all?(result) && Enum.count(result) != 0
  end
end
