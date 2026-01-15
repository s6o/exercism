defmodule S6o.ProviderRoutingTest do
  use ExUnit.Case
  alias S6o.ProviderRouting

  test "default routing table loading" do
    assert(is_map(ProviderRouting.route_table!()))
  end

  test "payment routing with and empty route table" do
    pay_req = S6o.PaymentRequest.btc!(1000)
    result = ProviderRouting.route_payment(pay_req, %{})
    assert(result == {:error, {:route_mismatch, "BTC", 1000}})
  end

  test "partial payment routing mismatch on amount" do
    pay_req = S6o.PaymentRequest.btc!(100_000)

    result =
      ProviderRouting.route_payment(pay_req, %{
        {"BTC", 10_000, &Kernel.</2} => S6o.Providers.ProviderBtc
      })

    assert(result == {:error, {:route_mismatch, "BTC", 100_000}})
  end
end
