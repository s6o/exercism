defmodule ExBanking.Data do
  @moduledoc """
  Most basic set of input data from the public `ExBanking` API.
  """
  @type t :: %__MODULE__{
          :amount => nil | number(),
          :currency => nil | String.t(),
          :user => String.t(),
          :ts => pos_integer()
        }
  defstruct [
    :amount,
    :currency,
    :user,
    :ts
  ]

  @doc """
  Create `Data` item with initial validation of allowed argument combinations.

  ## Examples

    iex> ExBanking.Data.create("john")
    {:ok, %ExBanking.Data{amount: nil, currency: nil, user: "john", ts: <nanoseconds>}}

    iex> ExBanking.Data.create("john", "EUR")
    {:ok, %ExBanking.Data{amount: nil, currency: "EUR", user: "john", ts: <nanoseconds>}}

    iex> ExBanking.Data.create("john", "EUR", 1.23)
    {:ok, %ExBanking.Data{amount: 1.23, currency: "EUR", user: "john", ts: <nanoseconds>}}

    iex> ExBanking.Data.create("")
    {:error, :wrong_arguments}

    iex> ExBanking.Data.create("", "")
    {:error, :wrong_arguments}

    iex> ExBanking.Data.create("john", "")
    {:error, :wrong_arguments}

    iex> ExBanking.Data.create("john", "EUR", 0)
    {:error, :wrong_arguments}

    iex> ExBanking.Data.create("john", "EUR", -24)
    {:error, :wrong_arguments}

    iex> ExBanking.Data.create("john", "EUR", -2.42)
    {:error, :wrong_arguments}
  """
  @spec create(String.t(), String.t() | nil, number() | nil) ::
          {:error, :wrong_arguments} | {:ok, ExBanking.Data.t()}
  def create(user, currency \\ nil, amount \\ nil)

  def create("", nil, nil), do: {:error, :wrong_arguments}

  def create(user, nil, nil) when is_binary(user), do: _create(user, nil, nil)

  def create(user, "", nil) when is_binary(user), do: {:error, :wrong_arguments}

  def create(user, currency, nil) when is_binary(user) and is_binary(currency),
    do: _create(user, currency, nil)

  def create(user, currency, amount)
      when is_binary(user) and is_binary(currency) and amount > 0,
      do: _create(user, currency, amount)

  def create(_, _, _), do: {:error, :wrong_arguments}

  defp _create(user, currency, amount) do
    {:ok,
     %__MODULE__{
       amount: amount,
       currency: currency,
       user: user,
       ts: DateTime.utc_now() |> DateTime.to_unix(:nanosecond)
     }}
  end
end
