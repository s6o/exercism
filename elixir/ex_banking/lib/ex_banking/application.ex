defmodule ExBanking.Application do
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: BankTasks},
      {ExBanking.RateLimiter, 10},
      {ExBanking, nil}
    ]

    opts = [strategy: :one_for_one, name: ExBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
