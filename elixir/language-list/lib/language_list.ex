defmodule LanguageList do
  def new(), do: []

  def add(list, language), do: [language | list]

  def remove(list) do
    case list do
      [] -> []
      [_ | rest] -> rest
    end
  end

  def first(list) do
    case list do
      [] -> nil
      [first | _] -> first
    end
  end

  def count(list) do
    case list do
      [] -> 0
      [_ | rest] -> 1 + count(rest)
    end
  end

  def functional_list?(list) do
    case list do
      [] ->
        false

      [item | rest] ->
        if String.downcase(item) == "elixir" do
          true
        else
          functional_list?(rest)
        end
    end
  end
end
