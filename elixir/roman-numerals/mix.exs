defmodule RomanNumerals.MixProject do
  use Mix.Project

  def project do
    [
      app: :roman_numerals,
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:publicist, "~> 1.1"}
    ]
  end
end
