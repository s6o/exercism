defmodule Username do
  def sanitize(username) do
    username
    |> Enum.reduce([], fn c, acc ->
      case c do
        u when u == ?ä -> acc ++ [?a, ?e]
        u when u == ?ö -> acc ++ [?o, ?e]
        u when u == ?ü -> acc ++ [?u, ?e]
        s when s == ?ß -> acc ++ [?s, ?s]
        v when v == ?_ or (v >= ?a and v <= ?z) -> acc ++ [v]
        _ -> acc
      end
    end)
  end
end
