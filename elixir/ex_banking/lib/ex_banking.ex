defmodule ExBanking do
  @moduledoc false
  @type bank_state :: %{required(String.t()) => ExBanking.Account.t()}
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: ExBanking)
  end

  @doc """
  Function creates new user in the system. New user has zero balance of any currency.

  ## Examples

    iex> ExBanking.create_user("")
    {:error, :wrong_arguments}

    iex> ExBanking.create_user(231)
    {:error, :wrong_arguments}

    iex> ExBanking.create_user("john")
    :ok

    iex> ExBanking.create_user("juku"); ExBanking.create_user("juku")
    {:error, :user_already_exists}

    iex> ExBanking.create_user("John")
    :ok
  """
  @spec create_user(user :: String.t()) :: :ok | {:error, :wrong_arguments | :user_already_exists}
  def create_user(user) when is_binary(user), do: GenServer.call(ExBanking, {:create_user, user})

  def create_user(_), do: {:error, :wrong_arguments}

  @doc """
  Increases user’s balance in given currency by amount value.
  Returns `new_balance` of the user in given format.

  ## Examples

    iex> ExBanking.create_user("jeremy"); ExBanking.deposit("johnny", 100, "eur")
    {:error, :user_does_not_exist}

    iex> ExBanking.create_user("jane"); ExBanking.deposit("jane", 100, "eur")
    {:ok, 100.00}
  """
  @spec deposit(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number}
          | {:error, :wrong_arguments | :user_does_not_exist | :too_many_requests_to_user}
  def deposit(user, amount, currency)
      when is_binary(user) and user != "" and is_number(amount) and is_binary(currency) and
             currency != "" do
    GenServer.call(ExBanking, {:deposit, {user, amount, currency}})
  end

  def deposit(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Decreases user’s balance in given currency by amount value.
  Returns new_balance of the user in given format.

  ## Examples

    iex> ExBanking.create_user("smith"); ExBanking.deposit("smith", 100, "eur"); ExBanking.withdraw("smith", 70, "eur")
    {:ok, 30.00}

    iex> ExBanking.create_user("penny"); ExBanking.deposit("penny", 100, "eur"); ExBanking.withdraw("penny", 170, "eur")
    {:error, :not_enough_money}
  """
  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number}
          | {:error,
             :wrong_arguments
             | :user_does_not_exist
             | :not_enough_money
             | :too_many_requests_to_user}
  def withdraw(user, amount, currency)
      when is_binary(user) and user != "" and is_number(amount) and is_binary(currency) and
             currency != "" do
    GenServer.call(ExBanking, {:withdraw, {user, amount, currency}})
  end

  def withdraw(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Returns balance of the user in given format.

  ## Examples

    iex> ExBanking.create_user("jdoe"); ExBanking.get_balance("jdoe", "eur")
    {:ok, 0.00}

    iex> ExBanking.create_user("jsm"); ExBanking.deposit("jsm", 42, "eur"); ExBanking.get_balance("jsm", "eur")
    {:ok, 42.00}
  """
  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number}
          | {:error, :wrong_arguments | :user_does_not_exist | :too_many_requests_to_user}
  def get_balance(user, currency)
      when is_binary(user) and user != "" and is_binary(currency) and currency != "" do
    GenServer.call(ExBanking, {:balance, {user, currency}})
  end

  def get_balance(_, _), do: {:error, :wrong_arguments}

  @doc """
  Decreases from_user’s balance in given currency by amount value.
  Increases to_user’s balance in given currency by amount value.
  Returns balance of from_user and to_user in given format.

  ## Examples

    iex> ExBanking.create_user("a"); ExBanking.create_user("b"); ExBanking.deposit("b", 1.42, "eur"); ExBanking.send("b", "a", 0.42, "eur")
    {:ok, 1.0, 0.42}

    iex(2)> ExBanking.create_user("d"); ExBanking.create_user("c"); ExBanking.deposit("c", 10, "eur"); ExBanking.send("c", "d", 15, "eur")
    {:error, :not_enough_money}
  """
  @spec send(
          from_user :: String.t(),
          to_user :: String.t(),
          amount :: number,
          currency :: String.t()
        ) ::
          {:ok, from_user_balance :: number, to_user_balance :: number}
          | {:error,
             :wrong_arguments
             | :not_enough_money
             | :sender_does_not_exist
             | :receiver_does_not_exist
             | :too_many_requests_to_sender
             | :too_many_requests_to_receiver}
  def send(from_user, to_user, amount, currency)
      when is_binary(from_user) and from_user != "" and is_binary(to_user) and to_user != "" and
             is_number(amount) and is_binary(currency) and currency != "" do
    GenServer.call(ExBanking, {:send, {from_user, to_user, amount, currency}})
  end

  def send(_, _, _, _), do: {:error, :wrong_arguments}

  ### Impl-s ###################################################################

  @impl true
  @spec init(any) :: {:ok, bank_state()}
  def init(_arg) do
    initial_state = %{}
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:create_user, user}, _from, state) do
    if Map.has_key?(state, user) do
      {:reply, {:error, :user_already_exists}, state}
    else
      with {:ok, data} <- ExBanking.Data.create(user),
           {:ok, cmd} <- ExBanking.Command.create(data, :assign),
           {:ok, account} <- ExBanking.Account.create(cmd) do
        {:reply, :ok, Map.put(state, user, account)}
      else
        {:error, :wrong_arguments} = e ->
          {:reply, e, state}
      end
    end
  end

  @impl true
  def handle_call({:balance, {user, currency}}, _from, state) do
    if not Map.has_key?(state, user) do
      {:reply, {:error, :user_does_not_exist}, state}
    else
      with {:ok, data} <- ExBanking.Data.create(user, currency),
           {:ok, cmd} <- ExBanking.Command.create(data, :balance),
           {:ok, account} <- ExBanking.Account.update(cmd, Map.get(state, user)) do
        {:reply, {:ok, Float.round(Map.get(account.balances, currency, 0.0) * 1.0, 2)},
         Map.put(state, user, account)}
      else
        {:error, :wrong_arguments} = e ->
          {:reply, e, state}
      end
    end
  end

  @impl true
  def handle_call({:deposit, {user, amount, currency}}, _from, state) do
    if not Map.has_key?(state, user) do
      {:reply, {:error, :user_does_not_exist}, state}
    else
      with {:ok, data} <- ExBanking.Data.create(user, currency, amount),
           {:ok, cmd} <- ExBanking.Command.create(data, :deposit),
           {:ok, account} <- ExBanking.Account.update(cmd, Map.get(state, user)) do
        {:reply, {:ok, Float.round(account.balances[currency] * 1.0, 2)},
         Map.put(state, user, account)}
      else
        {:error, :wrong_arguments} = e ->
          {:reply, e, state}
      end
    end
  end

  @impl true
  def handle_call({:withdraw, {user, amount, currency}}, _from, state) do
    if not Map.has_key?(state, user) do
      {:reply, {:error, :user_does_not_exist}, state}
    else
      with {:ok, data} <- ExBanking.Data.create(user, currency, amount),
           {:ok, cmd} <- ExBanking.Command.create(data, :withdraw),
           {:ok, account} <- ExBanking.Account.update(cmd, Map.get(state, user)) do
        {:reply, {:ok, Float.round(account.balances[currency] * 1.0, 2)},
         Map.put(state, user, account)}
      else
        {:error, :wrong_arguments} = e ->
          {:reply, e, state}

        {:not_enough_money, account} ->
          {:reply, {:error, :not_enough_money}, Map.put(state, user, account)}
      end
    end
  end

  @impl true
  def handle_call({:send, {from_user, to_user, amount, currency}}, _from, state) do
    if not Map.has_key?(state, from_user) do
      {:reply, {:error, :sender_does_not_exist}, state}
    else
      if not Map.has_key?(state, to_user) do
        {:reply, {:error, :receiver_does_not_exist}, state}
      else
        with {:ok, from_data} <- ExBanking.Data.create(from_user, currency, amount),
             {:ok, from_cmd} <- ExBanking.Command.create(from_data, :withdraw),
             {:ok, from_account} <- ExBanking.Account.update(from_cmd, Map.get(state, from_user)),
             {:ok, to_data} <- ExBanking.Data.create(to_user, currency, amount),
             {:ok, to_cmd} <- ExBanking.Command.create(to_data, :deposit),
             {:ok, to_account} <- ExBanking.Account.update(to_cmd, Map.get(state, to_user)) do
          {:reply,
           {:ok, Float.round(Map.get(from_account.balances, currency, 0.0) * 1.0, 2),
            Float.round(Map.get(to_account.balances, currency, 0.0) * 1.0, 2)},
           Map.put(state, from_user, from_account) |> Map.put(to_user, to_account)}
        else
          {:error, :wrong_arguments} = e ->
            {:reply, e, state}

          {:not_enough_money, account} ->
            {:reply, {:error, :not_enough_money}, Map.put(state, account.user, account)}
        end
      end
    end
  end
end
