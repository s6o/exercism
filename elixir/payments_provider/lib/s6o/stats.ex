defmodule S6o.Stats do
  @moduledoc """
  Generate statistics based on `S6o.PaymentLogger` compatible log entries.
  """
  @type provider_entry_t :: %{
          total: non_neg_integer(),
          successes: non_neg_integer(),
          rate: non_neg_integer()
        }
  @type provider_stat_t :: %{required(String.t()) => provider_stat_t()}
  @type provider_summary_t :: %{total_entries: non_neg_integer(), providers: provider_stat_t()}

  @spec provider_stats(list(S6o.PaymentLogger.entry_t())) :: provider_summary_t()
  def provider_stats(entries) do
    initial = %{
      total_entries: 0,
      providers: %{}
    }

    entries
    |> Enum.reduce(initial, fn {_, %S6o.PaymentRequest{metadata: md, provider: pn}},
                               %{total_entries: te, providers: ps} = acc ->
      %{
        acc
        | total_entries: te + 1,
          providers:
            if Map.has_key?(md, :attempts) do
              pstat = Map.get(ps, pn, %{total: 0, successes: 0, rate: 0})

              new_total = pstat.total + 1

              new_succ =
                pstat.successes + Enum.count(Enum.filter(md.attempts, &payment_success/1))

              new_rate = Kernel.div(new_succ * 100, new_total)

              new_pstat =
                %{pstat | total: new_total, successes: new_succ, rate: new_rate}

              Map.put(ps, pn, new_pstat)
            else
              ps
            end
      }
    end)
  end

  defp payment_success(%S6o.PaymentReceipt{status: :success}), do: true
  defp payment_success(_), do: false
end
