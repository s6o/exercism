defmodule LibraryFees do
  def datetime_from_string(string) do
    DateTime.from_iso8601(string)
    |> (fn {:ok, uts, _} -> DateTime.to_naive(uts) end).()
  end

  def before_noon?(datetime) do
    with {:ok, dt} <- DateTime.from_naive(datetime, "Etc/UTC"),
         {:ok, noon} <- Time.new(12, 0, 0) do
      DateTime.to_time(dt) |> Time.compare(noon) == :lt
    end
  end

  def return_date(checkout_datetime) do
    with {:ok, dt} <- DateTime.from_naive(checkout_datetime, "Etc/UTC") do
      days = if before_noon?(checkout_datetime), do: 28, else: 29
      DateTime.add(dt, days, :day) |> DateTime.to_date()
    end
  end

  def days_late(planned_return_date, actual_return_datetime) do
    with {:ok, dt} <- DateTime.from_naive(actual_return_datetime, "Etc/UTC") do
      if Date.before?(dt, planned_return_date) do
        0
      else
        Date.diff(dt, planned_return_date)
      end
    end
  end

  def monday?(datetime) do
    with {:ok, dt} <- DateTime.from_naive(datetime, "Etc/UTC") do
      DateTime.to_date(dt) |> Date.day_of_week() == 1
    end
  end

  def calculate_late_fee(checkout, return, rate) do
    expected_return = datetime_from_string(checkout) |> return_date()
    actual_return = datetime_from_string(return)
    rate_days = days_late(expected_return, actual_return)

    discount =
      actual_return
      |> monday?()
      |> (fn b -> if(b, do: 0.5, else: 1) end).()

    Kernel.floor(rate * rate_days * discount)
  end
end
