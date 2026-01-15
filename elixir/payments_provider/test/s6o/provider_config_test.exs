defmodule S6o.ProviderConfigTest do
  use ExUnit.Case
  alias S6o.ProviderConfig

  test "currency code error if it is not a string/binary" do
    assert_raise(ArgumentError, "currency_code_invalid", fn ->
      ProviderConfig.new!(nil, %{min: 100, max: 200}, 100)
    end)
  end

  test "currency code error if length is not equals to 3" do
    assert_raise(ArgumentError, "currency_code_length", fn ->
      ProviderConfig.new!("US", %{min: 100, max: 200}, 100)
    end)
  end

  test "delay range error if not a map" do
    assert_raise(ArgumentError, "delay_range_not_map", fn ->
      ProviderConfig.new!("EUR", nil, 100)
    end)
  end

  test "delay range error if a map, but missing required members" do
    assert_raise(ArgumentError, "delay_range_missing_min_max", fn ->
      ProviderConfig.new!("EUR", %{}, 100)
    end)
  end

  test "delay range error if a map, but invalid member value range" do
    assert_raise(ArgumentError, "delay_out_of_range", fn ->
      ProviderConfig.new!("EUR", %{min: -100, max: 0}, 100)
    end)

    assert_raise(ArgumentError, "delay_max_less_than_min", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 50}, 100)
    end)
  end

  test "success rate error if not an integer" do
    assert_raise(ArgumentError, "success_rate_invalid", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 200}, nil)
    end)
  end

  test "success rate error if success rate out of range 0-100" do
    assert_raise(ArgumentError, "success_rate_out_of_range", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 300}, -1)
    end)

    assert_raise(ArgumentError, "success_rate_out_of_range", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 300}, 101)
    end)
  end

  test "threshold amount error if not an integer" do
    assert_raise(ArgumentError, "threshold_amount_invalid", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 200}, 50, nil)
    end)
  end

  test "threshold amount error if an integer out of range" do
    assert_raise(ArgumentError, "threshold_amount_out_of_range", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 200}, 50, -1)
    end)
  end

  test "threshold check error if not a function" do
    assert_raise(ArgumentError, "threshold_check_invalid", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 200}, 50, 0, nil)
    end)
  end

  test "threshold check error if a function but not a comparison function" do
    assert_raise(ArgumentError, "threshold_check_function_invalid", fn ->
      ProviderConfig.new!("EUR", %{min: 100, max: 200}, 50, 0, &Kernel.||/2)
    end)
  end

  test "payment provider extraction when not routed" do
    pay_req = S6o.PaymentRequest.btc!(100)
    assert(ProviderConfig.payment_provider(pay_req) == {:error, :unknown_payment_provider})
  end

  test "payment provider extraction after routing" do
    pay_req = S6o.PaymentRequest.btc!(100)
    pay_req_routed = %{pay_req | :provider => Atom.to_string(S6o.Providers.ProviderBtc)}
    assert(ProviderConfig.payment_provider(pay_req_routed) == {:ok, S6o.Providers.ProviderBtc})
  end

  test "provider configuration success_rate initialization: 0 (zero)" do
    config = S6o.ProviderConfig.new!("EUR", %{min: 100, max: 200}, 0)
    %{dist: dist} = config
    assert(Enum.filter(dist, fn x -> x end) |> Enum.count() == 0)
  end

  test "provider configuration success_rate initialization: 100 (max)" do
    config = S6o.ProviderConfig.new!("EUR", %{min: 100, max: 200}, 100)
    %{dist: dist} = config
    assert(Enum.filter(dist, fn x -> x end) |> Enum.count() == 100)
  end
end
