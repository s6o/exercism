defmodule Day1Debug do
  def run do
    :some_atom
    |> Atom.to_string()
    |> String.split("")
    |> Enum.count
    |> to_string
    |> IO.puts
  end
end
