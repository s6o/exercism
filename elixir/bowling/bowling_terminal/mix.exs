defmodule BowlingTerminal.MixProject do
  use Mix.Project

  def project do
    [
      app: :bowling_terminal,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BowlingTerminal, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.2"},
      {:ratatouille, "~> 0.5.1"},
      {:tesla, "~> 1.4"}
    ]
  end
end
