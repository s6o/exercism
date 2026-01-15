defmodule S6o.Providers.ProviderBtc do
  @moduledoc """
  Payment Provider for BTC with a 70% success rate.
  """
  @behaviour S6o.ProviderModule

  @impl S6o.ProviderModule
  @spec config() :: S6o.ProviderConfig.t()
  def config() do
    S6o.ProviderConfig.new!("BTC", %{min: 100, max: 500}, 70)
  end

  @impl S6o.ProviderModule
  @spec process(payment_request :: S6o.PaymentRequest.t()) ::
          {:error,
           :invalid_process_payment_request
           | :payment_request_missing_provider
           | :payment_request_provider_mismatch
           | :provider_currency_mismatch
           | :provider_network_failure
           | :provider_threshold_amount_mismatch
           | :provider_threshold_check_mismatch}
          | {:ok, S6o.PaymentReceipt.t()}
  def process(%S6o.PaymentRequest{} = s), do: S6o.ProviderConfig.process(s, __MODULE__)

  def process(_), do: {:error, :invalid_process_payment_request}
end
