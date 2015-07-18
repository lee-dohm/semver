defmodule Semver.Mixfile do
  use Mix.Project

  def project do
    [
      app: :semver,
      name: "Semver",
      version: "0.1.0",
      elixir: "~> 1.0",
      source_url: "https://github.com/lee-dohm/semver",
      homepage_url: "https://github.com/lee-dohm/semver",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:espec, "~> 0.6.3", only: :test},
      {:ex_doc, "~> 0.7", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev}
    ]
  end
end
