defmodule ExBanking.Command do
  @moduledoc """
  A state change request for the ExBanking system.
  """
  @type command :: :assign | :balance | :deposit | :withdraw
  @type t :: %__MODULE__{
          :command => command(),
          :data => ExBanking.Data.t()
        }
  defstruct [
    :command,
    :data
  ]

  @doc """
  Create a state change request aka Command.

  ## Examples

    iex> ExBanking.Data.create("John") |> ExBanking.Command.create(:assign)
    {:ok,
     %ExBanking.Command{
       command: :assign,
       data: %ExBanking.Data{amount: nil, currency: nil, user: "John", ts: 1708716185}
     }}

    iex> ExBanking.Data.create("john") |> ExBanking.Command.create(:balance)
    {:error, :wrong_arguments}

    iex> ExBanking.Data.create("john", "EUR") |> ExBanking.Command.create(:balance)
    {:ok,
     %ExBanking.Command{
       command: :balance,
       data: %ExBanking.Data{amount: nil, currency: "EUR", user: "john", ts: 1708704017}
     }}

    iex> ExBanking.Data.create("john", "EUR", 100) |> ExBanking.Command.create(:deposit)
    {:ok,
     %ExBanking.Command{
       command: :deposit,
       data: %ExBanking.Data{amount: 100, currency: "EUR", user: "john", ts: 1708704219}
     }}

    iex> ExBanking.Data.create("john", "EUR") |> ExBanking.Command.create(:deposit)
    {:error, :wrong_arguments}
  """
  @spec create({:ok, ExBanking.Data.t()} | ExBanking.Data.t(), command()) ::
          {:ok, %__MODULE__{}} | {:error, :wrong_arguments}
  def create({:ok, %ExBanking.Data{} = data}, command), do: _create(data, command)
  def create(%ExBanking.Data{} = data, command), do: _create(data, command)
  def create(_, _), do: {:error, :wrong_arguments}

  defp _create(%ExBanking.Data{user: user, currency: currency, amount: amount} = data, command) do
    if is_binary(user) and user != "" do
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
          {:ok,
           %__MODULE__{
             command: command,
             data: data
           }}
      end
    else
      {:error, :wrong_arguments}
    end
  end
end
