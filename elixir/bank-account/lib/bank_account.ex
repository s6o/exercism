defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = Agent.start(fn -> 0 end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: :ok | :already_closed
  def close_bank(account) do
    if Process.alive?(account) do
      Agent.stop(account)
    else
      :already_closed
    end
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    if Process.alive?(account) do
      Agent.get(account, fn b -> b end)
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    if Process.alive?(account) do
      :ok = Agent.update(account, fn b -> b + amount end)
    else
      {:error, :account_closed}
    end
  end
end
