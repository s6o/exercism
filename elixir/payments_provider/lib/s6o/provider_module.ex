defmodule S6o.ProviderModule do
  @moduledoc """
  The behaviour expected to be implemented by every specific payment provider
  module instance.
  """
  @type t :: module()

  @callback config() :: S6o.ProviderConfig.t()

  @callback process(S6o.PaymentRequest.t()) :: {:error, any()} | {:ok, S6o.PaymentReceipt.t()}
end
