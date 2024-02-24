defmodule ExBanking.Event do
  @type event ::
          :account_created
          | :balance_checked
          | :deposited
          | :overdrawn
          | :unknown_command
          | :withdrawn
  @type t :: %__MODULE__{
          :data => ExBanking.Data.t(),
          :event => event(),
          :ts => pos_integer()
        }
  defstruct [
    :data,
    :event,
    :ts
  ]
end
