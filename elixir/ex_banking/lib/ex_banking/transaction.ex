defmodule ExBanking.Transaction do
  @doc """
  Create an `ExBanking.Account` for specified user.
  """
  @spec create_user(data :: ExBanking.Data.t()) ::
          {:ok, ExBanking.Account.t()} | {:error, :wrong_arguments}
  def create_user(%ExBanking.Data{user: user} = data) when is_binary(user) and user != "" do
    with {:ok, cmd} <- ExBanking.Command.create(data, :assign),
         {:ok, account} <- ExBanking.Account.create(cmd) do
      {:ok, account}
    end
  end

  def create_user(_), do: {:error, :wrong_arguments}

  @doc """
  Add a new non-zero deposit amount in specified currency to specified `ExBanking.Account`.
  """
  @spec new_deposit(account :: ExBanking.Account.t(), data :: ExBanking.Data.t()) ::
          {:error, :wrong_arguments} | {:ok, ExBanking.Account.t()}
  def new_deposit(
        %ExBanking.Account{user: user} = account,
        %ExBanking.Data{user: user, currency: currency, amount: amount} = data
      )
      when is_binary(user) and user != "" and is_binary(currency) and currency != "" and
             is_number(amount) and amount > 0 do
    with {:ok, cmd} <- ExBanking.Command.create(data, :deposit),
         {:ok, updated} <- ExBanking.Account.update(cmd, account) do
      {:ok, updated}
    end
  end

  def new_deposit(_, _), do: {:error, :wrong_arguments}

  @doc """
  Add a new non-zero withdraw amount in specified currency to specified `ExBanking.Account`.
  """
  @spec new_withdraw(account :: ExBanking.Account.t(), data :: ExBanking.Data.t()) ::
          {:error, :wrong_arguments}
          | {:not_enough_money, ExBanking.Account.t()}
          | {:ok, ExBanking.Account.t()}
  def new_withdraw(
        %ExBanking.Account{user: user} = account,
        %ExBanking.Data{
          user: user,
          currency: currency,
          amount: amount
        } = data
      )
      when is_binary(user) and user != "" and is_binary(currency) and currency != "" and
             is_number(amount) and amount > 0 do
    with {:ok, cmd} <- ExBanking.Command.create(data, :withdraw),
         {:ok, updated} <- ExBanking.Account.update(cmd, account) do
      {:ok, updated}
    end
  end

  def new_withdraw(_, _), do: {:error, :wrong_arguments}

  @doc """
  Add `balanced_checked` event to specified `ExBanking.Account`'s event log.
  """
  @spec request_balance(account :: ExBanking.Account.t(), data :: ExBanking.Data.t()) ::
          {:error, :wrong_arguments} | {:ok, ExBanking.Account.t()}
  def request_balance(
        %ExBanking.Account{user: user} = account,
        %ExBanking.Data{currency: currency} = data
      )
      when is_binary(user) and user != "" and is_binary(currency) and currency != "" do
    with {:ok, cmd} <- ExBanking.Command.create(data, :balance),
         {:ok, updated} <- ExBanking.Account.update(cmd, account) do
      {:ok, updated}
    end
  end

  def request_balance(_, _), do: {:error, :wrong_arguments}

  @doc """
  Add a new non-zero amount transfer in specified currency between specified accounts.
  """
  @spec send(
          from_account :: ExBanking.Account.t(),
          to_account :: ExBanking.Account.t(),
          data :: ExBanking.Data.t()
        ) ::
          {:error, :wrong_arguments}
          | {:not_enough_money, ExBanking.Account.t()}
          | {:ok, ExBanking.Account.t(), ExBanking.Account.t()}
  def send(
        %ExBanking.Account{user: from_user} = from_account,
        %ExBanking.Account{user: to_user} = to_account,
        %ExBanking.Data{currency: currency, amount: amount} = data
      )
      when is_binary(from_user) and from_user != "" and is_binary(to_user) and to_user != "" and
             is_binary(currency) and currency != "" and is_number(amount) and amount > 0 do
    with {:ok, from_cmd} <- ExBanking.Command.create(%{data | user: from_user}, :withdraw),
         {:ok, from_updated} <- ExBanking.Account.update(from_cmd, from_account),
         {:ok, to_cmd} <- ExBanking.Command.create(%{data | user: to_user}, :deposit),
         {:ok, to_updated} <- ExBanking.Account.update(to_cmd, to_account) do
      {:ok, from_updated, to_updated}
    end
  end

  def send(_, _, _), do: {:error, :wrong_arguments}
end
