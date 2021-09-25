defmodule BowlingHall.GameSupervisor do
  use Supervisor

  def start_link(default) do
    Supervisor.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(default) do
    children = [
      {BowlingHall.GameServer, default}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
