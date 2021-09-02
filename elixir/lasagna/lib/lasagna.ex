defmodule Lasagna do
  @spec expected_minutes_in_oven :: non_neg_integer()
  def expected_minutes_in_oven, do: 40

  @spec remaining_minutes_in_oven(elapsed_minutes :: pos_integer()) :: integer()
  def remaining_minutes_in_oven(elapsed_minutes) do
    expected_minutes_in_oven() |> Kernel.-(elapsed_minutes)
  end

  @spec preparation_time_in_minutes(layers :: pos_integer()) :: non_neg_integer()
  def preparation_time_in_minutes(layers)
      when is_integer(layers) and layers > 0,
      do: layers * 2

  def preparation_time_in_minutes(_), do: 0

  @spec total_time_in_minutes(layers :: pos_integer, elapsed_minuts :: pos_integer()) ::
          pos_integer
  def total_time_in_minutes(layers, elapsed_minutes) do
    layers |> preparation_time_in_minutes() |> Kernel.+(elapsed_minutes)
  end

  @spec alarm :: String.t()
  def alarm(), do: "Ding!"
end
