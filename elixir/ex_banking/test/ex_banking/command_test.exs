defmodule ExBanking.CommandTest do
  use ExUnit.Case
  alias ExBanking.Command

  test "all commands fail if user is missing from ExBanking.Input struct" do
    data = %ExBanking.Input{
      amount: nil,
      currency: nil,
      user: ""
    }

    assert Command.create(data, :assign) == {:error, :wrong_arguments}
    assert Command.create(data, :balance) == {:error, :wrong_arguments}
    assert Command.create(data, :deposit) == {:error, :wrong_arguments}
    assert Command.create(data, :withdraw) == {:error, :wrong_arguments}
  end

  test ":balance command fails if currency is not set in ExBanking.Input struct" do
    data1 = %ExBanking.Input{
      amount: nil,
      currency: nil,
      user: "john"
    }

    data2 = %ExBanking.Input{
      amount: nil,
      currency: "",
      user: "john"
    }

    assert Command.create(data1, :balance) == {:error, :wrong_arguments}
    assert Command.create(data2, :balance) == {:error, :wrong_arguments}
  end

  test ":balance command fails if amount is set in ExBanking.Input struct" do
    data1 = %ExBanking.Input{
      amount: 100,
      currency: "$",
      user: "john"
    }

    data2 = %ExBanking.Input{
      amount: -2.50,
      currency: "$",
      user: "john"
    }

    assert Command.create(data1, :balance) == {:error, :wrong_arguments}
    assert Command.create(data2, :balance) == {:error, :wrong_arguments}
  end

  test ":deposit and :withdraw commands fail if currency is not set in ExBanking.Input struct" do
    data1 = %ExBanking.Input{
      amount: nil,
      currency: nil,
      user: "john"
    }

    data2 = %ExBanking.Input{
      amount: nil,
      currency: "",
      user: "john"
    }

    assert Command.create(data1, :deposit) == {:error, :wrong_arguments}
    assert Command.create(data2, :deposit) == {:error, :wrong_arguments}
    assert Command.create(data1, :withdraw) == {:error, :wrong_arguments}
    assert Command.create(data2, :withdraw) == {:error, :wrong_arguments}
  end

  test ":deposit and :withdraw commands fail if amount is not set or negative in ExBanking.Input struct" do
    data1 = %ExBanking.Input{
      amount: nil,
      currency: "€",
      user: "john"
    }

    data2 = %ExBanking.Input{
      amount: "",
      currency: "€",
      user: "john"
    }

    data3 = %ExBanking.Input{
      amount: -24,
      currency: "€",
      user: "john"
    }

    data4 = %ExBanking.Input{
      amount: 0,
      currency: "€",
      user: "john"
    }

    assert Command.create(data1, :deposit) == {:error, :wrong_arguments}
    assert Command.create(data2, :deposit) == {:error, :wrong_arguments}
    assert Command.create(data3, :deposit) == {:error, :wrong_arguments}
    assert Command.create(data4, :deposit) == {:error, :wrong_arguments}

    assert Command.create(data1, :withdraw) == {:error, :wrong_arguments}
    assert Command.create(data2, :withdraw) == {:error, :wrong_arguments}
    assert Command.create(data3, :withdraw) == {:error, :wrong_arguments}
    assert Command.create(data4, :withdraw) == {:error, :wrong_arguments}
  end
end
