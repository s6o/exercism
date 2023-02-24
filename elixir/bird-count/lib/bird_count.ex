defmodule BirdCount do
  def today([]), do: nil
  def today([today | _]), do: today
  def today(_), do: throw(ArgumentError)

  def increment_day_count([]), do: [1]
  def increment_day_count([today | rest]), do: [today + 1 | rest]
  def increment_day_count(_), do: throw(ArgumentError)

  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([0 | _]), do: true
  def has_day_without_birds?([_ | rest]), do: has_day_without_birds?(rest)
  def has_day_without_birds?(_), do: throw(ArgumentError)

  def total([]), do: 0
  def total([s]), do: s
  def total([a, b | rest]), do: total([a + b | rest])
  def total(_), do: throw(ArgumentError)

  def busy_days([]), do: 0
  def busy_days([c]), do: abs(c) - 1
  def busy_days([c, i | rest]) when c < 0 and i >= 5, do: busy_days([c - 1 | rest])
  def busy_days([c, i | rest]) when c < 0 and i < 5, do: busy_days([c | rest])
  def busy_days([i | rest]) when i >= 5, do: busy_days([-2 | rest])
  def busy_days([_ | rest]), do: busy_days([-1 | rest])
  def busy_days(_), do: throw(ArgumentError)
end
