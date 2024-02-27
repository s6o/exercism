defmodule ExBanking.Account do
  @moduledoc """
  Each `Account` provides a materliazed view of latest state of amounts per currency
  and a log (list) of `Event`s applied over time aka account state.
  """
  @type t :: %__MODULE__{
          :balances => %{required(String.t()) => ExBanking.Currency.t()},
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
  def create({:ok, %ExBanking.Command{name: :assign} = command}), do: create(command)

  def create(%ExBanking.Command{name: :assign} = command) do
    {:ok,
     %__MODULE__{
       balances: %{},
       events: [
         %ExBanking.Event{
           currency: command.currency,
           name: :account_created,
           user: command.user,
           ts: command.ts
         }
       ],
       user: command.user
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
        %ExBanking.Command{} = command,
        %ExBanking.Account{balances: balances, events: [%ExBanking.Event{} | _] = events} =
          account
      ) do
    {status, event, balance_f} =
      case command.name do
        :balance ->
          {:ok, :balance_checked, &deposit_identity/2}

        :deposit ->
          {:ok, :deposited, &ExBanking.Currency.add/2}

        :withdraw ->
          if Map.has_key?(balances, command.currency.code) and
               ExBanking.Currency.is_equal_or_greater!(
                 Map.get(balances, command.currency.code),
                 command.currency
               ) do
            {:ok, :withdrawn, &ExBanking.Currency.subtract/2}
          else
            {:not_enough_money, :overdrawn, &deposit_identity/2}
          end

        _ ->
          {:unknown_command, :unknown_command, &deposit_identity/2}
      end

    new_balances =
      if status == :ok and not is_nil(command.currency) and
           Map.has_key?(balances, command.currency.code) do
        last_balance = Map.get(balances, command.currency.code)
        updated_balance = balance_f.(last_balance, command.currency) |> (fn {:ok, b} -> b end).()
        Map.put(balances, command.currency.code, updated_balance)
      else
        if not is_nil(command.currency) and command.name == :deposit do
          Map.put(balances, command.currency.code, command.currency)
        else
          balances
        end
      end

    new_event = %ExBanking.Event{
      currency: command.currency,
      name: event,
      user: command.user,
      ts: command.ts
    }

    {status, %{account | balances: new_balances, events: [new_event | events]}}
  end

  def update(_, _), do: {:error, :wrong_arguments}

  defp deposit_identity(a, _b) do
    case a do
      {:ok, _} ->
        a

      _ ->
        {:ok, a}
    end
  end

  @doc """
  Merge an `ExBanking.Account`'s latest `ExBanking.Event` into another `ExBanking.Account`.
  """
  @spec merge_into_from(into :: ExBanking.Account.t(), from :: ExBanking.Account.t()) ::
          ExBanking.Account.t()
  def merge_into_from(%ExBanking.Account{} = into, %ExBanking.Account{} = from) do
    [latest_event | _] = from.events

    balance_f =
      case latest_event.name do
        :deposited ->
          &ExBanking.Currency.add/2

        :withdrawn ->
          &ExBanking.Currency.subtract/2

        _ ->
          &deposit_identity/2
      end

    new_balances =
      if not is_nil(latest_event.currency) and
           Map.has_key?(into.balances, latest_event.currency.code) do
        last_balance = Map.get(into.balances, latest_event.currency.code)

        updated_balance =
          balance_f.(last_balance, latest_event.currency) |> (fn {:ok, b} -> b end).()

        Map.put(into.balances, latest_event.currency.code, updated_balance)
      else
        if not is_nil(latest_event.currency) and latest_event.name == :deposited do
          Map.put(into.balances, latest_event.currency.code, latest_event.currency)
        else
          into.balances
        end
      end

    %{into | balances: new_balances, events: [latest_event | into.events]}
  end
end
