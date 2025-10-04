defmodule Leet.MixProject do
  use Mix.Project

  def project do
    [
      app: :leet,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls]
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
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.15", only: [:dev, :test]},
      {:jason, "~> 1.4"},
      {:mimic, "~> 1.1", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      test: ["test"],
      qc: [
        "format",
        "dialyzer",
        "credo --strict"
      ]
    ]
  end
end
