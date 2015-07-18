defmodule Semver do
  @moduledoc """
  Utilities for working with semver-compliant version strings.
  """
  @vsn "0.1.0"
  @pattern ~r"""
             ^v?
             (?<major>0|[1-9]\d*)\.
             (?<minor>0|[1-9]\d*)\.
             (?<patch>0|[1-9]\d*)
             (-(?<prerelease>[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?
             (\+(?<build>[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?
             $
             """x

  @doc """
  Module version.
  """
  def version, do: @vsn

  @doc """
  Validates a version string.
  """
  def is_valid(version) do
    version =~ @pattern
  end

  def parse(version) do
    cond do
      is_valid(version) -> parse_valid(version)
      true -> {:error, :invalid}
    end
  end

  defp parse_valid(version) do
    [major, minor, patch] = Enum.map String.split(version, ~r/\./), fn(part) ->
      {num, _} = Integer.parse(part)
      num
    end

    {:ok, %{major: major, minor: minor, patch: patch}}
  end
end
