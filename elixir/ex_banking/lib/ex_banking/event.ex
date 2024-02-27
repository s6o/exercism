defmodule ExBanking.Event do
  @type event ::
          :account_created
          | :balance_checked
          | :deposited
          | :overdrawn
          | :unknown_command
          | :withdrawn
  @type t :: %__MODULE__{
          :currency => nil | ExBanking.Currency.t(),
          :name => event(),
          :ts => pos_integer(),
          :user => String.t()
        }
  defstruct [
    :currency,
    :name,
    :ts,
    :user
  ]
end
