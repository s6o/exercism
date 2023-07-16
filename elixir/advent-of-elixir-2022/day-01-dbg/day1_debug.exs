defmodule Day1Debug do
  def run do
    :some_atom
    |> Atom.to_string()
    |> String.split("")
    |> Enum.count
    |> to_string
    |> dbg
    |> IO.puts
  end
end

Day1Debug.run()
