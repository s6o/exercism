defmodule FreelancerRates do
  defp daily_hours(), do: 8.0
  defp billable_days(), do: 22.0

  def daily_rate(hourly_rate) do
    daily_hours() * hourly_rate
  end

  def apply_discount(before_discount, discount) do
    before_discount - discount / 100 * before_discount
  end

  def monthly_rate(hourly_rate, discount) do
    billable_days()
    |> Kernel.*(daily_rate(hourly_rate))
    |> apply_discount(discount)
    |> Kernel.ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily_spend = hourly_rate |> daily_rate() |> apply_discount(discount)
    (budget / daily_spend) |> Float.floor(1)
  end
end
