defmodule ExBanking.Account do
  @moduledoc """
  Each `Account` provides a materliazed view of latest state of amounts per currency
  and a log (list) of `Event`s applied over time aka account state.
  """
  @type t :: %__MODULE__{
          :balances => %{required(String.t()) => number()},
          :events => [ExBanking.Event.t()],
          :user => String.t()
        }

  defstruct [
    :balances,
    :events,
    :user
  ]

  @doc """
  Initialize a new `Account` from `:assign` command.
  """
  @spec create(ExBanking.Command.t()) :: {:ok, ExBanking.Account.t()} | {:error, :wrong_arguments}
  def create({:ok, %ExBanking.Command{command: :assign} = command}), do: create(command)

  def create(%ExBanking.Command{command: :assign} = command) do
    {:ok,
     %__MODULE__{
       balances: %{},
       events: [
         %ExBanking.Event{
           ts: DateTime.utc_now() |> DateTime.to_unix(),
           event: :account_created,
           data: command.data
         }
       ],
       user: command.data.user
     }}
  end

  def create(_), do: {:error, :wrong_arguments}

  @doc """
  Given a `ExBanking.Command` update specified `ExBanking.Account`'s state.
  Unknown commands are logged in the `Account` as `:unknown_command` events.
  Attempts to overdraw the balance are also logged as `:overdrawn` events.
  """
  @spec update({:ok, ExBanking.Command.t()} | ExBanking.Command.t(), ExBanking.Account.t()) ::
          {:ok, ExBanking.Account.t()}
          | {:error, :wrong_arguments}
          | {:not_enough_money, ExBanking.Account.t()}
          | {:unknown_command, ExBanking.Account.t()}
  def update({:ok, %ExBanking.Command{} = command}, %ExBanking.Account{} = account),
    do: update(command, account)

  def update(
        %ExBanking.Command{command: command, data: %ExBanking.Data{} = data},
        %ExBanking.Account{balances: balances, events: [%ExBanking.Event{} | _] = events} =
          account
      ) do
    {status, event, balance_f} =
      case command do
        :balance ->
          {:ok, :balance_checked, &deposit_identity/2}

        :deposit ->
          {:ok, :deposited, &+/2}

        :withdraw ->
          if Map.has_key?(balances, data.currency) and
               Map.get(balances, data.currency) >= data.amount do
            {:ok, :withdrawn, &-/2}
          else
            {:not_enough_money, :overdrawn, &deposit_identity/2}
          end

        _ ->
          {:unknown_command, :unknown_command, &deposit_identity/2}
      end

    new_balances =
      if Map.has_key?(balances, data.currency) do
        last_balance = Map.get(balances, data.currency)
        Map.put(balances, data.currency, balance_f.(last_balance, data.amount))
      else
        if is_number(data.amount) do
          Map.put(balances, data.currency, data.amount)
        else
          balances
        end
      end

    new_event = %ExBanking.Event{
      ts: DateTime.utc_now() |> DateTime.to_unix(),
      event: event,
      data: data
    }

    {status, %{account | balances: new_balances, events: [new_event | events]}}
  end

  def update(_, _), do: {:error, :wrong_arguments}

  defp deposit_identity(a, _b), do: a
end
