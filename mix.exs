defmodule Chrono.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chrono,
      version: "0.0.2",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Chrono.Application, []},
      extra_applications: [:logger, :runtime_tools, :elixir_google_spreadsheets]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:poison, "~> 2.0", override: true},
      {:contentful, "~> 0.1.1"},
      {:earmark, "~> 1.2"},
      {:distillery, "~> 1.4", runtime: false},
      {:mix_docker, "~> 0.5.0"},
      {:vex, "~> 0.6.0"},
      {:elixir_google_spreadsheets, "~> 0.1.8"}
    ]
  end
end
