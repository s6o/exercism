defmodule ExBanking.DataTest do
  use ExUnit.Case

  test "only with user" do
    {:ok, data} = ExBanking.Data.create("john")
    assert is_nil(data.amount)
    assert is_nil(data.currency)
    assert data.user == "john"
    assert is_number(data.ts)
  end

  test "with user and currency" do
    {:ok, data} = ExBanking.Data.create("john", "EUR")
    assert is_nil(data.amount)
    assert is_binary(data.currency)
    assert data.currency != ""
    assert data.user == "john"
    assert is_number(data.ts)
  end

  test "with user, currency and amount" do
    {:ok, data} = ExBanking.Data.create("john", "EUR", 1.23)
    assert is_number(data.amount)
    assert data.amount > 0
    assert is_binary(data.currency)
    assert data.currency != ""
    assert data.user == "john"
    assert is_number(data.ts)
  end

  test "empty user string" do
    assert ExBanking.Data.create("") == {:error, :wrong_arguments}
  end

  test "empty user and currency strings" do
    assert ExBanking.Data.create("", "") == {:error, :wrong_arguments}
  end

  test "with user, but empty currency string" do
    assert ExBanking.Data.create("john", "") == {:error, :wrong_arguments}
  end

  test "with user and currency, but 0 amount" do
    assert ExBanking.Data.create("john", "EUR", 0) == {:error, :wrong_arguments}
  end

  test "with user, currency, but negative amount" do
    assert ExBanking.Data.create("john", "EUR", -24) == {:error, :wrong_arguments}
  end

  test "with user, currency, but negative float amount" do
    assert ExBanking.Data.create("john", "EUR", -2.42) == {:error, :wrong_arguments}
  end
end
