defmodule WineCellar do
  def explain_colors() do
    [
      white: "Fermented without skin contact.",
      red: "Fermented with skin contact using dark-colored grapes.",
      rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
    ]
  end

  def filter(cellar, color, opts \\ []) do
    wines = filter_by_color(cellar, color)
    Enum.reduce(opts, wines, &apply_filter/2)
  end

  defp apply_filter({:year, year}, wines), do: filter_by_year(wines, year)
  defp apply_filter({:country, country}, wines), do: filter_by_country(wines, country)
  defp apply_filter(_, wines), do: wines

  defp filter_by_color(cellar, year)
  defp filter_by_color([], _year), do: []

  defp filter_by_color([{color, wine} | tail], color) do
    [wine | filter_by_color(tail, color)]
  end

  defp filter_by_color([{_, _} | tail], color) do
    filter_by_color(tail, color)
  end

  # The functions below do not need to be modified.

  defp filter_by_year(wines, year)
  defp filter_by_year([], _year), do: []

  defp filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  defp filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  defp filter_by_country(wines, country)
  defp filter_by_country([], _country), do: []

  defp filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  defp filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
