defmodule Counter.Core do
  @moduledoc """
  Functional core logic.
  """

  @doc """
  Increment passed in `value` by one.

  ## Examples

      iex> Counter.Core.increment(0)
      1

  """
  def increment(value), do: value + 1
end
