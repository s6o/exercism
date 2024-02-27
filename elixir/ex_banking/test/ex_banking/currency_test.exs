defmodule ExBanking.CurrencyTest do
  use ExUnit.Case
  alias ExBanking.Currency

  test "Currency struct construction with valid input" do
    {:ok, c} = Currency.new("eur", 1.25)
    assert c.fractions === 10000
    assert c.subunits === 100
    assert c.units === 1_250_000

    {:ok, c} = Currency.new("aaa")
    assert c.units === 0
  end

  test "default Currency for euros" do
    {:ok, c} = Currency.euro(1.25)
    assert c.fractions === 10000
    assert c.subunits === 100
    assert c.units === 1_250_000
    assert c.symbol === "€"
  end

  test "to_float conversions" do
    {:ok, c1} = Currency.euro(1.25)
    {:ok, c2} = Currency.euro(1.33)
    assert c1.units === 1_250_000
    assert c2.units === 1_330_000

    {:ok, f1} = Currency.to_float(c1)
    {:ok, f2} = Currency.to_float(c2)
    assert f1 === 1.25
    assert f2 === 1.33
  end

  test "addtion" do
    {:ok, result} =
      Currency.euro(1.25)
      |> Currency.add(Currency.euro(1.33))
      |> Currency.to_float()

    assert result === 2.58

    {:ok, result} =
      Currency.euro(0.675)
      |> Currency.add(Currency.euro(0.675))
      |> Currency.to_float()

    assert result === 1.35
  end

  test "subtraction" do
    {:ok, result} =
      Currency.euro(1.25)
      |> Currency.subtract(Currency.euro(1.33))
      |> Currency.to_float()

    assert result === -0.08

    {:ok, result} =
      Currency.euro(0.675)
      |> Currency.subtract(Currency.euro(0.675))
      |> Currency.to_float()

    assert result === 0.0
  end

  test "comparison" do
    Currency.euro(1.25)
    |> Currency.is_equal_or_greater!(Currency.euro(1.25))
    |> assert

    Currency.euro(1.33)
    |> Currency.is_equal_or_greater!(Currency.euro(1.25))
    |> assert

    result =
      Currency.euro(0.5)
      |> Currency.is_equal_or_greater!(Currency.euro(1.25))

    assert result === false
  end
end
