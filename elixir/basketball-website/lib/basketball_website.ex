defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    String.split(path, ".")
    |> Enum.reduce(data, fn key, acc -> acc[key] end)
  end

  def get_in_path(data, path) do
    Kernel.get_in(data, String.split(path, "."))
  end
end
