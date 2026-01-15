defmodule S6o.PaymentLogger do
  @moduledoc """
  The behaviour expected to be implemented by every specific payment logging service.
  """
  @type t :: module()
  @type entry_t :: {String.t(), S6o.PaymentRequest.t()}

  @callback entries() :: list(entry_t())

  @callback log({:ok, S6o.PaymentRequest.t()} | S6o.PaymentRequest.t()) :: :ok
end
