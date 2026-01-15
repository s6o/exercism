defmodule S6o.StatsLogger do
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

defmodule S6o.ProviderBtc100 do
  @moduledoc false
  @behaviour S6o.ProviderModule

  @impl S6o.ProviderModule
  def config(), do: S6o.ProviderConfig.new!("BTC", %{min: 10, max: 50}, 100)

  @impl S6o.ProviderModule
  def process(%S6o.PaymentRequest{} = s), do: S6o.ProviderConfig.process(s, __MODULE__)

  def process(_), do: {:error, :invalid_process_payment_request}
end

defmodule S6o.StatsTest do
  use ExUnit.Case

  test "BTC payment provider stats with 100% success rate" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.ProviderBtc100
    }

    {:ok, _pid} = start_supervised({S6o.StatsLogger, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.StatsLogger, 2)

    1..10
    |> Enum.map(fn i -> S6o.PaymentRequest.btc!(i * 1000) end)
    |> Enum.each(fn pr ->
      S6o.PaymentProcessor.process_payment(pr, proc_state)
    end)

    entries = S6o.StatsLogger.entries()

    stats =
      S6o.Stats.provider_stats(entries)

    pstat = Map.get(stats.providers, Atom.to_string(S6o.ProviderBtc100))

    assert(stats.total_entries == 10)
    assert(pstat.total == pstat.successes)
    assert(pstat.rate == 100)
  end

  test "BTC payment provider success rate without retries" do
    route_table = %{
      {"BTC", 0, &Kernel.==/2} => S6o.Providers.ProviderBtc
    }

    {:ok, _pid} = start_supervised({S6o.StatsLogger, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.StatsLogger, 2)

    1..10
    |> Enum.map(fn i -> S6o.PaymentRequest.btc!(i * 1000) end)
    |> Enum.each(fn pr ->
      S6o.PaymentProcessor.process_payment(pr, proc_state)
    end)

    entries = S6o.StatsLogger.entries()

    stats =
      S6o.Stats.provider_stats(entries)

    assert(stats.total_entries == 10)
  end

  test "euro provider stat grouping" do
    route_table = %{
      {"EUR", 10_000, &Kernel.</2} => S6o.Providers.ProviderEurSmall,
      {"EUR", 10_000, &Kernel.>=/2} => S6o.Providers.ProviderEur
    }

    {:ok, _pid} = start_supervised({S6o.StatsLogger, []})

    proc_state = S6o.PaymentProcessor.new!(route_table, S6o.StatsLogger, 2)

    1..10
    |> Enum.map(fn i -> S6o.PaymentRequest.eur!(i * 1700) end)
    |> Enum.each(fn pr ->
      S6o.PaymentProcessor.process_payment(pr, proc_state)
    end)

    entries = S6o.StatsLogger.entries()

    stats =
      S6o.Stats.provider_stats(entries)

    pstat_a = Map.get(stats.providers, Atom.to_string(S6o.Providers.ProviderEurSmall))
    pstat_b = Map.get(stats.providers, Atom.to_string(S6o.Providers.ProviderEur))

    assert(stats.total_entries == 10)
    assert(pstat_a.total == 5 and pstat_a.total == pstat_b.total)
  end
end
