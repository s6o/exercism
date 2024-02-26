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

  test "account merge deposits" do
    {:ok, init_account} =
      ExBanking.Data.create("adam")
      |> ExBanking.Command.create(:assign)
      |> ExBanking.Account.create()

    {:ok, process_1} =
      ExBanking.Data.create("adam", "eur", 25)
      |> ExBanking.Command.create(:deposit)
      |> ExBanking.Account.update(init_account)

    {:ok, process_2} =
      ExBanking.Data.create("adam", "eur", 75)
      |> ExBanking.Command.create(:deposit)
      |> ExBanking.Account.update(init_account)

    merged =
      init_account
      |> ExBanking.Account.merge_into_from(process_1)
      |> ExBanking.Account.merge_into_from(process_2)

    assert Map.get(merged.balances, "eur") == 100

    assert Map.equal?(
             Map.from_struct(Enum.at(merged.events, 0)),
             Map.from_struct(Enum.at(process_2.events, 0))
           )

    assert Map.equal?(
             Map.from_struct(Enum.at(merged.events, 1)),
             Map.from_struct(Enum.at(process_1.events, 0))
           )

    assert Map.equal?(
             Map.from_struct(Enum.at(merged.events, 2)),
             Map.from_struct(Enum.at(init_account.events, 0))
           )
  end
end
