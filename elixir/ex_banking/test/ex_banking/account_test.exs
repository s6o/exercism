defmodule ExBanking.AccountTest do
  use ExUnit.Case

  test "account initialization" do
    {:ok, account} =
      ExBanking.Data.create("John")
      |> ExBanking.Command.create(:assign)
      |> ExBanking.Account.create()

    assert Map.equal?(account.balances, %{})
  end

  test "balance checks" do
    {:ok, init_account} =
      ExBanking.Data.create("John")
      |> ExBanking.Command.create(:assign)
      |> ExBanking.Account.create()

    assert Map.equal?(init_account.balances, %{})

    {:ok, data} = ExBanking.Data.create("John", "EUR")

    {:ok, account} =
      data
      |> ExBanking.Command.create(:balance)
      |> ExBanking.Account.update(init_account)

    [event | _] = account.events
    assert event.event == :balance_checked
    assert Map.equal?(account.balances, %{})
  end

  test "deposits" do
    {:ok, init_account} =
      ExBanking.Data.create("John")
      |> ExBanking.Command.create(:assign)
      |> ExBanking.Account.create()

    assert Map.equal?(init_account.balances, %{})

    {:ok, data} = ExBanking.Data.create("John", "EUR", 100)

    {:ok, account} =
      data
      |> ExBanking.Command.create(:deposit)
      |> ExBanking.Account.update(init_account)

    assert account.balances["EUR"] == data.amount

    {:ok, data} = ExBanking.Data.create("John", "EUR", 50)

    {:ok, account} =
      data
      |> ExBanking.Command.create(:deposit)
      |> ExBanking.Account.update(account)

    assert account.balances["EUR"] == 150
  end

  test "withdraws" do
    {:ok, init_account} =
      ExBanking.Data.create("John")
      |> ExBanking.Command.create(:assign)
      |> ExBanking.Account.create()

    assert Map.equal?(init_account.balances, %{})

    {:ok, data} = ExBanking.Data.create("John", "EUR", 100)

    {:ok, account} =
      data
      |> ExBanking.Command.create(:deposit)
      |> ExBanking.Account.update(init_account)

    assert account.balances["EUR"] == data.amount

    {:ok, data} = ExBanking.Data.create("John", "EUR", 50)

    {:ok, account} =
      data
      |> ExBanking.Command.create(:withdraw)
      |> ExBanking.Account.update(account)

    assert account.balances["EUR"] == 50

    {:ok, data} = ExBanking.Data.create("John", "EUR", 70)

    with {:ok, _} <-
           data
           |> ExBanking.Command.create(:withdraw)
           |> ExBanking.Account.update(account) do
    else
      {:not_enough_money, account} ->
        assert account.balances["EUR"] == 50
        [event | _] = account.events
        assert event.event == :overdrawn
    end
  end
end
