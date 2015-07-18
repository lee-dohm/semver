defmodule Semver.Mixfile do
  use Mix.Project

  @homepage "https://github.com/lee-dohm/semver"
  @version File.read!("VERSION") |> String.strip

  def project do
    [
      app: :semver,
      version: @version,
      elixir: "~> 1.0",
      source_url: @homepage,
      homepage_url: @homepage,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps,
      package: package
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:espec, "~> 0.6.3", only: :test},
      {:ex_doc, "~> 0.7", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE.md VERSION CHANGELOG.md),
      licenses: ["MIT"],
      links: %{"GitHub" => @homepage}
    ]
  end
end
