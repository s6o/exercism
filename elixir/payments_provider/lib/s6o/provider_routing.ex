defmodule S6o.ProviderRouting do
  @moduledoc false
  @type route_key_t ::
          {S6o.ProviderConfig.currency_code_t(), S6o.ProviderConfig.threshold_amount_t(),
           S6o.ProviderConfig.threshold_check_t()}
  @type routes_t :: %{required(route_key_t()) => S6o.ProviderModule.t()}

  @doc """
  The default routing configuration.
  Checks that all provider modules in the configuration can be loaded, will raise
  on module load failures.
  """
  @spec route_table!() :: routes_t()
  def route_table!() do
    rt = %{
      {"BTC", 0, &Kernel.==/2} => S6o.Providers.ProviderBtc,
      {"EUR", 10_000, &Kernel.</2} => S6o.Providers.ProviderEurSmall,
      {"EUR", 10_000, &Kernel.>=/2} => S6o.Providers.ProviderEur
    }

    Code.ensure_all_loaded!(Map.values(rt))
    rt
  end

  @doc """
  Find and set payment request provider accordingly to specified routing table.
  """
  @spec route_payment(payment_request :: S6o.PaymentRequest.t(), route_table :: routes_t()) ::
          {:error,
           {:route_mismatch, S6o.ProviderConfig.currency_code_t(),
            S6o.ProviderConfig.threshold_amount_t()}}
          | {:ok, S6o.PaymentRequest.t()}
  def route_payment(%S6o.PaymentRequest{currency: cc, amount: amount} = pr, route_table) do
    routes =
      route_table
      |> Enum.filter(fn {{currency_code, threshold, check}, _} ->
        currency_code == cc and (threshold == 0 or check.(amount, threshold))
      end)

    if Enum.count(routes) == 1 do
      {_, module} = Enum.at(routes, 0)
      {:ok, %{pr | :provider => Atom.to_string(module)}}
    else
      {:error, {:route_mismatch, cc, amount}}
    end
  end
end
