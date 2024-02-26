defmodule ExBanking do
  @moduledoc false
  @type bank_state :: %{accounts: :ets.tid()}
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
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
  def create_user(user) when is_binary(user) and user != "" do
    with {:ok, data} <- ExBanking.Data.create(user) do
      GenServer.call(ExBanking, {:create_user, data})
    end
  end

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
      when is_binary(user) and user != "" and is_number(amount) and amount > 0 and
             is_binary(currency) and
             currency != "" do
    with {:ok, _count} <- ExBanking.RateLimiter.register_request(user),
         {:ok, data} <- ExBanking.Data.create(user, currency, amount) do
      GenServer.call(ExBanking, {:deposit, data})
    else
      {:error, :wrong_arguments} = e -> e
      {:too_many_requests, _user} -> {:error, :too_many_requests_to_user}
    end
  end

  def deposit(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Decreases user’s balance in given currency by amount value.
  Returns new_balance of the user in given format.
  """
  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number}
          | {:error,
             :wrong_arguments
             | :user_does_not_exist
             | :not_enough_money
             | :too_many_requests_to_user}
  def withdraw(user, amount, currency)
      when is_binary(user) and user != "" and is_number(amount) and amount > 0 and
             is_binary(currency) and
             currency != "" do
    with {:ok, _count} <- ExBanking.RateLimiter.register_request(user),
         {:ok, data} <- ExBanking.Data.create(user, currency, amount) do
      GenServer.call(ExBanking, {:withdraw, data})
    else
      {:error, :wrong_arguments} = e -> e
      {:too_many_requests, _user} -> {:error, :too_many_requests_to_user}
    end
  end

  def withdraw(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Returns balance of the user in given format.

  ## Examples

    iex> ExBanking.create_user("jdoe"); ExBanking.get_balance("jdoe", "eur")
    {:ok, 0.00}
  """
  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number}
          | {:error, :wrong_arguments | :user_does_not_exist | :too_many_requests_to_user}
  def get_balance(user, currency)
      when is_binary(user) and user != "" and is_binary(currency) and currency != "" do
    with {:ok, _count} <- ExBanking.RateLimiter.register_request(user),
         {:ok, data} <- ExBanking.Data.create(user, currency) do
      GenServer.call(ExBanking, {:balance, data})
    else
      {:error, :wrong_arguments} = e -> e
      {:too_many_requests, _user} -> {:error, :too_many_requests_to_user}
    end
  end

  def get_balance(_, _), do: {:error, :wrong_arguments}

  @doc """
  Decreases from_user’s balance in given currency by amount value.
  Increases to_user’s balance in given currency by amount value.
  Returns balance of from_user and to_user in given format.
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
    with {:ok, _from_count} <- ExBanking.RateLimiter.register_request(from_user),
         {:ok, _to_count} <- ExBanking.RateLimiter.register_request(to_user),
         {:ok, data} <- ExBanking.Data.create(from_user, currency, amount) do
      GenServer.call(ExBanking, {:send, {from_user, to_user, data}})
    else
      {:error, :wrong_arguments} = e -> e
      {:too_many_requests, ^from_user} -> {:error, :too_many_requests_to_sender}
      {:too_many_requests, ^to_user} -> {:error, :too_many_requests_to_receiver}
    end
  end

  def send(_, _, _, _), do: {:error, :wrong_arguments}

  ### Impl-s ###################################################################

  @impl true
  @spec init(any) :: {:ok, bank_state()}
  def init(_arg) do
    table = :ets.new(:user_accounts, [:set, :protected])
    initial_state = %{accounts: table}
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:create_user, %ExBanking.Data{user: user} = data}, _from, state) do
    case :ets.lookup(state.accounts, user) do
      [] ->
        with {:ok, account} <- ExBanking.Transaction.create_user(data) do
          :ets.insert(state.accounts, {user, account})
          {:reply, :ok, state}
        else
          {:error, :wrong_arguments} = e ->
            {:reply, e, state}
        end

      [{_user, _}] ->
        {:reply, {:error, :user_already_exists}, state}
    end
  end

  @impl true
  def handle_call({:balance, %ExBanking.Data{user: user, currency: currency} = data}, from, state) do
    state_pid = self()

    Task.Supervisor.start_child(BankTasks, fn ->
      ExBanking.RateLimiter.request_completed(user)

      case :ets.lookup(state.accounts, user) do
        [] ->
          GenServer.reply(from, {:error, :user_does_not_exist})

        [{_user, account}] ->
          with {:ok, _} = result <- ExBanking.Transaction.request_balance(account, data) do
            Process.send_after(state_pid, {:update_state, from, currency, result}, 0)
          else
            {:error, :wrong_arguments} = e ->
              Process.send_after(state_pid, {:update_state, from, currency, e}, 0)
          end
      end
    end)

    {:noreply, state}
  end

  @impl true
  def handle_call({:deposit, %ExBanking.Data{user: user, currency: currency} = data}, from, state) do
    state_pid = self()

    Task.Supervisor.start_child(BankTasks, fn ->
      ExBanking.RateLimiter.request_completed(user)

      case :ets.lookup(state.accounts, user) do
        [] ->
          GenServer.reply(from, {:error, :user_does_not_exist})

        [{_user, account}] ->
          with {:ok, _} = result <- ExBanking.Transaction.new_deposit(account, data) do
            Process.send_after(state_pid, {:update_state, from, currency, result}, 0)
          else
            e ->
              Process.send_after(state_pid, {:update_state, from, currency, e}, 0)
          end
      end
    end)

    {:noreply, state}
  end

  @impl true
  def handle_call(
        {:withdraw, %ExBanking.Data{user: user, currency: currency} = data},
        from,
        state
      ) do
    state_pid = self()

    Task.Supervisor.start_child(BankTasks, fn ->
      ExBanking.RateLimiter.request_completed(user)

      case :ets.lookup(state.accounts, user) do
        [] ->
          GenServer.reply(from, {:error, :user_does_not_exist})

        [{_user, account}] ->
          with {:ok, _} = result <- ExBanking.Transaction.new_withdraw(account, data) do
            Process.send_after(state_pid, {:update_state, from, currency, result}, 0)
          else
            e ->
              Process.send_after(state_pid, {:update_state, from, currency, e}, 0)
          end
      end
    end)

    {:noreply, state}
  end

  @impl true
  def handle_call(
        {:send, {from_user, to_user, %ExBanking.Data{currency: currency} = data}},
        from,
        state
      ) do
    state_pid = self()

    Task.Supervisor.start_child(BankTasks, fn ->
      ExBanking.RateLimiter.request_completed(from_user)
      ExBanking.RateLimiter.request_completed(to_user)

      case {:ets.lookup(state.accounts, from_user), :ets.lookup(state.accounts, to_user)} do
        {[], _} ->
          GenServer.reply(from, {:error, :sender_does_not_exist})

        {_, []} ->
          GenServer.reply(from, {:error, :receiver_does_not_exist})

        {[{_sender, from_account}], [{_receiver, to_account}]} ->
          with {:ok, _, _} = result <-
                 ExBanking.Transaction.send(from_account, to_account, data) do
            Process.send_after(state_pid, {:update_state, from, currency, result}, 0)
          else
            e ->
              Process.send_after(state_pid, {:update_state, from, currency, e}, 0)
          end
      end
    end)

    {:noreply, state}
  end

  @impl true
  def handle_info({:update_state, from, currency, result}, state) do
    case result do
      {:error, :wrong_arguments} = e ->
        GenServer.reply(from, e)

      {:not_enough_money, account} ->
        case :ets.lookup(state.accounts, account.user) do
          [] ->
            GenServer.reply(from, {:error, :user_does_not_exist})

          [{_user, into}] ->
            merged = ExBanking.Account.merge_into_from(into, account)
            :ets.insert(state.accounts, {account.user, merged})
        end

        GenServer.reply(from, {:error, :not_enough_money})

      {:ok, account} ->
        case :ets.lookup(state.accounts, account.user) do
          [] ->
            GenServer.reply(from, {:error, :user_does_not_exist})

          [{_user, into}] ->
            merged = ExBanking.Account.merge_into_from(into, account)
            #            IO.inspect(merged, label: "event log #{DateTime.utc_now()}\n")
            :ets.insert(state.accounts, {account.user, merged})

            GenServer.reply(
              from,
              {:ok, Float.round(Map.get(merged.balances, currency, 0.0) * 1.0, 2)}
            )
        end

      {:ok, from_account, to_account} ->
        case :ets.lookup(state.accounts, from_account.user) do
          [] ->
            GenServer.reply(from, {:error, :user_does_not_exist})

          [{_user, into}] ->
            merged = ExBanking.Account.merge_into_from(into, from_account)
            :ets.insert(state.accounts, {from_account.user, merged})
        end

        case :ets.lookup(state.accounts, to_account.user) do
          [] ->
            GenServer.reply(from, {:error, :user_does_not_exist})

          [{_user, into}] ->
            merged = ExBanking.Account.merge_into_from(into, to_account)
            :ets.insert(state.accounts, {to_account.user, merged})
        end

        GenServer.reply(
          from,
          {:ok, Float.round(Map.get(from_account.balances, currency, 0.0) * 1.0, 2),
           Float.round(Map.get(to_account.balances, currency, 0.0) * 1.0, 2)}
        )
    end

    {:noreply, state}
  end
end
