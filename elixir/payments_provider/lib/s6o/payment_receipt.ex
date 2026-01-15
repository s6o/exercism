defmodule S6o.PaymentReceipt do
  @moduledoc false
  @type t :: %__MODULE__{
          id: String.t(),
          provider: String.t(),
          status: :success | :failure,
          timestamp: DateTime.t()
        }
  defstruct [
    :id,
    :provider,
    :status,
    :timestamp
  ]

  @doc """
  Create a new payment receipt based on specified `S6o.PaymentRequest.t()`.
  The `timestamp` is set to current date/time in UTC.
  """
  @spec new!(payment_request :: S6o.PaymentRequest.t(), status :: :failure | :success) ::
          S6o.PaymentReceipt.t()
  def new!(%S6o.PaymentRequest{provider: module}, status) do
    %__MODULE__{
      id: S6o.Uuid.new!(),
      provider: module,
      status: status,
      timestamp: DateTime.now!("Etc/UTC")
    }
  end
end
