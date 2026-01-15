defmodule S6o.ProviderAlwaysFail do
  @moduledoc false
  @behaviour S6o.ProviderModule

  @impl S6o.ProviderModule
  def config(), do: S6o.ProviderConfig.new!("BTC", %{min: 100, max: 500}, 0)

  @impl S6o.ProviderModule
  def process(%S6o.PaymentRequest{} = s), do: S6o.ProviderConfig.process(s, __MODULE__)

  def process(_), do: {:error, :invalid_process_payment_request}
end

defmodule S6o.ProviderAlwaysSucceed do
  @moduledoc false
  @behaviour S6o.ProviderModule

  @impl S6o.ProviderModule
  def config(), do: S6o.ProviderConfig.new!("BTC", %{min: 100, max: 500}, 100)

  @impl S6o.ProviderModule
  def process(%S6o.PaymentRequest{} = s), do: S6o.ProviderConfig.process(s, __MODULE__)

  def process(_), do: {:error, :invalid_process_payment_request}
end

defmodule S6o.LoggerDevNull do
  @moduledoc false
  @behaviour S6o.PaymentLogger

  @impl S6o.PaymentLogger
  def entries(), do: []

  @impl S6o.PaymentLogger
  def log(_), do: :ok
end

defmodule S6o.LoggerAgent do
  @moduledoc false
  @behaviour S6o.PaymentLogger
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{logs: :ets.new(:logs, [:set, :protected])} end, name: __MODULE__)
  end

  @impl S6o.PaymentLogger
  def entries(), do: Agent.get(__MODULE__, fn s -> :ets.tab2list(s.logs) end)

  @impl S6o.PaymentLogger
  def log({:ok, %S6o.PaymentRequest{} = pr}), do: log(pr)

  def log(%S6o.PaymentRequest{id: id} = pr) do
    Agent.update(__MODULE__, fn s ->
      :ets.insert(s.logs, {id, pr})
      s
    end)
  end
end

defmodule S6o.PaymentProcessorTest do
  use ExUnit.Case

  test "process_payment's intial failure" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderAlwaysFail
    }

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerDevNull, 2)
    pay_req = S6o.PaymentRequest.btc!(1000)
    {new_pay_req, result} = S6o.PaymentProcessor.process_payment(pay_req, proc_state)

    assert(result == {:error, :provider_network_failure})
    assert(Map.get(new_pay_req.metadata, :attempts, []) == [{:error, :provider_network_failure}])
  end

  test "payment request metadata attempt list is not populated beyond retry_max" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderAlwaysFail
    }

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerDevNull, 2)
    pay_req = S6o.PaymentRequest.btc!(1000)

    pay_req_max = %{
      pay_req
      | :metadata => %{
          :attempts => 1..3 |> Enum.map(fn _ -> {:error, :provider_network_failure} end)
        }
    }

    {new_pay_req, result} = S6o.PaymentProcessor.process_payment(pay_req_max, proc_state)

    assert(result == {:error, :provider_network_failure})
    assert(Map.get(new_pay_req.metadata, :attempts, []) |> Enum.count() == 3)
  end

  test "payment request is not retried when process_payment/2 was successful" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderAlwaysSucceed
    }

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerDevNull, 2)
    pay_req = S6o.PaymentRequest.btc!(1000)

    {pr1, r1} = S6o.PaymentProcessor.process_payment(pay_req, proc_state)
    {pr2, r2} = S6o.PaymentProcessor.retry_payment({pr1, r1}, proc_state)

    assert(pr1 == pr2 and r1 == r2)
  end

  test "payment receipt with success status is the last (first item) in attempts" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderAlwaysSucceed
    }

    {:ok, _pid} = start_supervised({S6o.LoggerAgent, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerAgent, 2)
    pay_req = S6o.PaymentRequest.btc!(1000)

    pay_req_failed = %{
      pay_req
      | :metadata => %{
          :attempts => [{:error, :provider_network_failure}]
        }
    }

    {new_pay_req, _result} =
      S6o.PaymentProcessor.retry_payment(
        {pay_req_failed, {:error, :provider_network_failure}},
        proc_state
      )

    attempts = Map.get(new_pay_req.metadata, :attempts)
    assert(attempts |> Enum.count() == 2)
    assert(is_struct(Enum.at(attempts, 0)))
    assert(S6o.LoggerAgent.entries() |> Enum.count() == 1)
  end

  test "logging of each payment request payment processing attempt" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderAlwaysSucceed
    }

    {:ok, _pid} = start_supervised({S6o.LoggerAgent, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerAgent, 2)

    1..10
    |> Enum.map(fn i -> S6o.PaymentRequest.btc!(i * 1000) end)
    |> Enum.each(fn pr -> S6o.PaymentProcessor.process_payment(pr, proc_state) end)

    assert(S6o.LoggerAgent.entries() |> Enum.count() == 10)
    assert(Enum.all?(S6o.LoggerAgent.entries(), fn {_, e} -> is_struct(e) end))
  end

  test "route mismatch" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderAlwaysSucceed
    }

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerDevNull, 2)
    pay_req = S6o.PaymentRequest.eur!(10_000)

    {new_pay_req, result} = S6o.PaymentProcessor.process_payment(pay_req, proc_state)
    expected_error = {:error, {:route_mismatch, "EUR", 10_000}}
    assert(result == expected_error)
    assert(Map.get(new_pay_req.metadata, :attempts, []) |> Enum.at(0) == expected_error)
  end

  test "BTC payment processing" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.Providers.ProviderBtc
    }

    {:ok, _pid} = start_supervised({S6o.LoggerAgent, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerAgent, 2)

    1..3
    |> Enum.map(fn i -> S6o.PaymentRequest.btc!(i * 1000) end)
    |> Enum.each(fn pr -> S6o.PaymentProcessor.process_payment(pr, proc_state) end)

    entries = S6o.LoggerAgent.entries()

    providers =
      entries
      |> Enum.filter(fn {_, %S6o.PaymentRequest{provider: p}} ->
        p == Atom.to_string(S6o.Providers.ProviderBtc)
      end)

    assert(Enum.count(entries) == 3)
    assert(Enum.count(providers) == 3)
  end

  test "EUR payment processing" do
    route_table = %{
      {"EUR", 10_000, &Kernel.</2} => S6o.Providers.ProviderEurSmall,
      {"EUR", 10_000, &Kernel.>=/2} => S6o.Providers.ProviderEur
    }

    {:ok, _pid} = start_supervised({S6o.LoggerAgent, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.LoggerAgent, 2)

    1..4
    |> Enum.map(fn i -> S6o.PaymentRequest.eur!(i * 4500) end)
    |> Enum.each(fn pr -> S6o.PaymentProcessor.process_payment(pr, proc_state) end)

    entries = S6o.LoggerAgent.entries()

    provider_group_a =
      entries
      |> Enum.filter(fn {_, %S6o.PaymentRequest{provider: p}} ->
        p == Atom.to_string(S6o.Providers.ProviderEurSmall)
      end)

    provider_group_b =
      entries
      |> Enum.filter(fn {_, %S6o.PaymentRequest{provider: p}} ->
        p == Atom.to_string(S6o.Providers.ProviderEur)
      end)

    assert(Enum.count(entries) == 4)
    assert(Enum.count(provider_group_a) == 2)
    assert(Enum.count(provider_group_b) == 2)
  end
end
