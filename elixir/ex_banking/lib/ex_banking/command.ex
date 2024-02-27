defmodule ExBanking.Command do
  @moduledoc """
  A state change request for the ExBanking system.
  """
  @type command :: :assign | :balance | :deposit | :withdraw
  @type t :: %__MODULE__{
          :currency => nil | ExBanking.Currency.t(),
          :name => command(),
          :user => String.t(),
          :ts => pos_integer()
        }
  defstruct [
    :currency,
    :name,
    :user,
    :ts
  ]

  @doc """
  Create a state change request aka Command.

  ## Examples

    iex> ExBanking.Input.create("John") |> ExBanking.Command.create(:assign)
    {:ok,
    %ExBanking.Command{
       currency: nil,
       name: :assign,
       ts: 1709048627045560000,
       user: "John"
    }}

    iex> ExBanking.Input.create("john") |> ExBanking.Command.create(:balance)
    {:error, :wrong_arguments}

    iex> ExBanking.Input.create("john", "EUR") |> ExBanking.Command.create(:balance)
    {:ok,
    %ExBanking.Command{
       currency: %ExBanking.Currency{
         code: "EUR",
         fractions: 10000,
         subunits: 100,
         symbol: "€",
         units: 0
       },
       name: :balance,
       ts: 1709052703928625000,
       user: "john"
    }}

    iex> ExBanking.Input.create("john", "EUR", 100) |> ExBanking.Command.create(:deposit)
    {:ok,
    %ExBanking.Command{
     currency: %ExBanking.Currency{
       code: "EUR",
       fractions: 10000,
       subunits: 100,
       symbol: "€",
       units: 100000000
     },
     name: :deposit,
     ts: 1709052751283265000,
     user: "john"
    }}

    iex> ExBanking.Input.create("john", "EUR") |> ExBanking.Command.create(:deposit)
    {:error, :wrong_arguments}
  """
  @spec create({:ok, ExBanking.Input.t()} | ExBanking.Input.t(), command()) ::
          {:ok, %__MODULE__{}} | {:error, :wrong_arguments}
  def create({:ok, %ExBanking.Input{} = data}, command), do: _create(data, command)
  def create(%ExBanking.Input{} = data, command), do: _create(data, command)
  def create(_, _), do: {:error, :wrong_arguments}

  defp _create(%ExBanking.Input{user: user, currency: currency, amount: amount} = data, command) do
    if is_binary(user) and user != "" and is_integer(data.ts) and data.ts > 0 do
      case command do
        :assign
        when not is_nil(currency) or not is_nil(amount) ->
          {:error, :wrong_arguments}

        :balance
        when is_nil(currency) or not is_binary(currency) or currency == "" or not is_nil(amount) ->
          {:error, :wrong_arguments}

        :deposit
        when is_nil(currency) or not is_binary(currency) or currency == "" or
               not is_number(amount) or amount <= 0 ->
          {:error, :wrong_arguments}

        :withdraw
        when is_nil(currency) or not is_binary(currency) or currency == "" or
               not is_number(amount) or amount <= 0 ->
          {:error, :wrong_arguments}

        _ ->
          currency =
            if command == :assign do
              nil
            else
              case String.downcase(currency) do
                "eur" ->
                  ExBanking.Currency.euro(if(is_number(amount), do: amount, else: 0.0))

                "usd" ->
                  ExBanking.Currency.usd(if(is_number(amount), do: amount, else: 0.0))

                _ ->
                  ExBanking.Currency.new(currency, if(is_number(amount), do: amount, else: 0.0))
              end
              |> (fn {:ok, c} -> %{c | code: currency} end).()
            end

          {:ok,
           %__MODULE__{
             currency: currency,
             name: command,
             user: user,
             ts: data.ts
           }}
      end
    else
      {:error, :wrong_arguments}
    end
  end
end
