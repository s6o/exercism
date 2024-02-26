defmodule ExBanking.RateLimiter do
  @moduledoc """
  Basic [Leaky Bucket](https://en.wikipedia.org/wiki/Leaky_bucket) style rate limiting.
  """
  @type limiter_state :: %{bucket_size: pos_integer()}
  use GenServer

  @spec start_link(bucket_size :: pos_integer()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(bucket_size) do
    GenServer.start_link(__MODULE__, bucket_size, name: RateLimiter)
  end

  @doc """
  Register a bucket's request.

  ## Examples

    iex> ExBanking.RateLimiter.register_request("adam")
    {:ok, 1}

    iex> ExBanking.RateLimiter.register_request("eve"); ExBanking.RateLimiter.register_request("eve")
    {:ok, 2}

    iex> ExBanking.RateLimiter.register_request("")
    {:error, :wrong_arguments}
  """
  @spec register_request(user :: String.t()) ::
          {:ok, pos_integer()}
          | {:error, :wrong_arguments}
          | {:too_many_requests, String.t()}
  def register_request(user) when is_binary(user) and user != "" do
    GenServer.call(RateLimiter, {:register_request, user})
  end

  def register_request(_), do: {:error, :wrong_arguments}

  @doc """
  Mark a bucket's request complete.

  ## Examples

    iex> ExBanking.RateLimiter.request_completed("eve")
    :ok
  """
  @spec request_completed(user :: String.t()) :: :ok | {:error, :wrong_arguments}
  def request_completed(user) when is_binary(user) and user != "" do
    GenServer.cast(RateLimiter, {:request_completed, user})
  end

  def request_completed(_), do: {:error, :wrong_arguments}

  ### Impl-s ###################################################################

  @impl true
  @spec init(pos_integer()) :: {:ok, limiter_state()}
  def init(bucket_size) do
    :ets.new(:user_limits, [:set, :protected, :named_table])
    {:ok, %{bucket_size: bucket_size}}
  end

  @impl true
  def handle_call({:register_request, user}, _from, state) do
    case :ets.lookup(:user_limits, user) do
      [] ->
        :ets.insert(:user_limits, {user, 1})
        {:reply, {:ok, 1}, state}

      [{_user, count}] ->
        if count < state.bucket_size do
          :ets.insert(:user_limits, {user, count + 1})
          {:reply, {:ok, count + 1}, state}
        else
          {:reply, {:too_many_requests, user}, state}
        end
    end
  end

  @impl true
  def handle_cast({:request_completed, user}, state) do
    case :ets.lookup(:user_limits, user) do
      [] ->
        {:noreply, state}

      [{_user, count}] ->
        if count > 0 do
          :ets.insert(:user_limits, {user, count - 1})
          {:noreply, state}
        end
    end
  end
end
