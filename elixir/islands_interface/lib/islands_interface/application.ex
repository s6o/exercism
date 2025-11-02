defmodule IslandsInterface.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      IslandsInterfaceWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:islands_interface, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: IslandsInterface.PubSub},
      # Start a worker by calling: IslandsInterface.Worker.start_link(arg)
      # {IslandsInterface.Worker, arg},
      IslandsInterfaceWeb.Presence,
      # Start to serve requests, typically the last entry
      IslandsInterfaceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IslandsInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IslandsInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
