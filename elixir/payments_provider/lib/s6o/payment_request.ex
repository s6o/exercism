defmodule S6o.PaymentRequest do
  @moduledoc """
  Capture payment request.
  Fields:
    * `id` - a UUID value
    * `amount` - the amount in base units, for BTC satoshis and for EUR cents
    * `currency` - the currency code (label) e.g. BTC, EUR etc.
    * `metadata` - payment metadata.
    * `provider` - by default an empty string, set to the payment provider module
      by payment routing
  """
  @type t :: %__MODULE__{
          id: String.t(),
          amount: pos_integer(),
          currency: String.t(),
          metadata: map(),
          provider: String.t()
        }
  defstruct [
    :id,
    :amount,
    :currency,
    :metadata,
    :provider
  ]

  @spec btc!(satoshis :: pos_integer()) :: t()
  @spec btc!(satoshis :: pos_integer(), metadata :: map()) :: t()
  def btc!(satoshis, metadata \\ %{}) when is_integer(satoshis) and satoshis > 0 do
    %__MODULE__{
      id: S6o.Uuid.new!(),
      amount: satoshis,
      currency: "BTC",
      metadata: metadata,
      provider: ""
    }
  end

  @spec eur!(euro_cents :: pos_integer()) :: t()
  @spec eur!(euro_cents :: pos_integer(), metadata :: map()) :: t()
  def eur!(euro_cents, metadata \\ %{}) when is_integer(euro_cents) and euro_cents > 0 do
    %__MODULE__{
      id: S6o.Uuid.new!(),
      amount: euro_cents,
      currency: "EUR",
      metadata: metadata,
      provider: ""
    }
  end

  @spec usd!(us_cents :: pos_integer()) :: t()
  @spec usd!(us_cents :: pos_integer(), metadata :: map()) :: t()
  def usd!(us_cents, metadata \\ %{}) when is_integer(us_cents) and us_cents > 0 do
    %__MODULE__{
      id: S6o.Uuid.new!(),
      amount: us_cents,
      currency: "USD",
      metadata: metadata,
      provider: ""
    }
  end
end
