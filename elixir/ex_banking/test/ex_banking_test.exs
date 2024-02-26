defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  test "balance after deposit" do
    last_result =
      [
        fn -> ExBanking.create_user("t1") end,
        fn -> ExBanking.deposit("t1", 42, "eur") end,
        fn -> ExBanking.get_balance("t1", "eur") end
      ]
      |> Enum.map(fn f -> f.() end)
      |> Enum.at(2)

    assert last_result == {:ok, 42.00}
  end

  test "send with enough money" do
    last_result =
      [
        fn -> ExBanking.create_user("t2") end,
        fn -> ExBanking.create_user("t3") end,
        fn -> ExBanking.deposit("t3", 1.42, "eur") end,
        fn -> ExBanking.send("t3", "t2", 0.42, "eur") end
      ]
      |> Enum.map(fn f -> f.() end)
      |> Enum.at(3)

    assert last_result == {:ok, 1.0, 0.42}
  end

  test "send with not enough money" do
    last_result =
      [
        fn -> ExBanking.create_user("t4") end,
        fn -> ExBanking.create_user("t5") end,
        fn -> ExBanking.deposit("t5", 10, "eur") end,
        fn -> ExBanking.send("t4", "t5", 15, "eur") end
      ]
      |> Enum.map(fn f -> f.() end)
      |> Enum.at(3)

    assert last_result == {:error, :not_enough_money}
  end

  test "deposit with withdraw" do
    last_result =
      [
        fn -> ExBanking.create_user("t6") end,
        fn -> ExBanking.deposit("t6", 100, "eur") end,
        fn -> ExBanking.withdraw("t6", 70, "eur") end
      ]
      |> Enum.map(fn f -> f.() end)
      |> Enum.at(2)

    assert last_result == {:ok, 30.00}
  end

  test "not enough money to withdraw" do
    last_result =
      [
        fn -> ExBanking.create_user("t7") end,
        fn -> ExBanking.deposit("t7", 100, "eur") end,
        fn -> ExBanking.withdraw("t7", 170, "eur") end
      ]
      |> Enum.map(fn f -> f.() end)
      |> Enum.at(2)

    assert last_result == {:error, :not_enough_money}
  end

  test "too many user requests" do
    ExBanking.create_user("t8")

    last_result =
      [
        fn -> ExBanking.deposit("t8", 1, "eur") end,
        fn -> ExBanking.deposit("t8", 2, "eur") end,
        fn -> ExBanking.deposit("t8", 3, "eur") end,
        fn -> ExBanking.deposit("t8", 4, "eur") end,
        fn -> ExBanking.deposit("t8", 5, "eur") end,
        fn -> ExBanking.deposit("t8", 6, "eur") end,
        fn -> ExBanking.deposit("t8", 7, "eur") end,
        fn -> ExBanking.deposit("t8", 8, "eur") end,
        fn -> ExBanking.deposit("t8", 9, "eur") end,
        fn -> ExBanking.deposit("t8", 10, "eur") end,
        fn -> ExBanking.deposit("t8", 11, "eur") end
      ]
      |> Enum.map(fn f -> Task.async(f) end)
      |> Enum.map(&Task.await/1)
      |> Enum.at(10)

    assert last_result == {:error, :too_many_requests_to_user}
  end

  test "too many sender requests" do
    ExBanking.create_user("t9")
    ExBanking.create_user("t10")
    ExBanking.deposit("t9", 10, "eur")

    last_result =
      [
        fn -> ExBanking.deposit("t9", 1, "eur") end,
        fn -> ExBanking.deposit("t9", 2, "eur") end,
        fn -> ExBanking.deposit("t9", 3, "eur") end,
        fn -> ExBanking.deposit("t9", 4, "eur") end,
        fn -> ExBanking.deposit("t9", 5, "eur") end,
        fn -> ExBanking.deposit("t9", 6, "eur") end,
        fn -> ExBanking.deposit("t9", 7, "eur") end,
        fn -> ExBanking.deposit("t9", 8, "eur") end,
        fn -> ExBanking.deposit("t9", 9, "eur") end,
        fn -> ExBanking.deposit("t9", 10, "eur") end,
        fn -> ExBanking.deposit("t9", 11, "eur") end,
        fn -> ExBanking.send("t9", "t10", 10, "eur") end
      ]
      |> Enum.map(fn f -> Task.async(f) end)
      |> Enum.map(&Task.await/1)
      |> Enum.at(11)

    assert last_result == {:error, :too_many_requests_to_sender}
  end

  test "too many receiver requests" do
    ExBanking.create_user("t11")
    ExBanking.create_user("t12")
    ExBanking.deposit("t12", 10, "eur")

    last_result =
      [
        fn -> ExBanking.deposit("t11", 1, "eur") end,
        fn -> ExBanking.deposit("t11", 2, "eur") end,
        fn -> ExBanking.deposit("t11", 3, "eur") end,
        fn -> ExBanking.deposit("t11", 4, "eur") end,
        fn -> ExBanking.deposit("t11", 5, "eur") end,
        fn -> ExBanking.deposit("t11", 6, "eur") end,
        fn -> ExBanking.deposit("t11", 7, "eur") end,
        fn -> ExBanking.deposit("t11", 8, "eur") end,
        fn -> ExBanking.deposit("t11", 9, "eur") end,
        fn -> ExBanking.deposit("t11", 10, "eur") end,
        fn -> ExBanking.send("t12", "t11", 5, "eur") end
      ]
      |> Enum.map(fn f -> Task.async(f) end)
      |> Enum.map(&Task.await/1)
      |> Enum.at(10)

    assert last_result == {:error, :too_many_requests_to_receiver}
  end
end
