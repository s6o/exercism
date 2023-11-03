defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    max_p = Keyword.get(options, :maximum_price, 100)

    for top <- tops,
        btm <- bottoms,
        top.base_color != btm.base_color and top.price + btm.price <= max_p do
      {top, btm}
    end
  end
end
