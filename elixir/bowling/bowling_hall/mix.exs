defmodule BowlingHall.MixProject do
  use Mix.Project

  def project do
    [
      app: :bowling_hall,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {BowlingHall.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bowling_score, path: "./../bowling_score"},
      {:exsync, "~> 0.2.4"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end
end
