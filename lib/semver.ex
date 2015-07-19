defmodule Semver do
  @moduledoc """
  Utilities for working with [semver.org](http://semver.org)-compliant version strings.
  """

  @vsn File.read!("VERSION") |> String.strip
  @pattern ~r"""
             ^v?
             (?<major>0|[1-9]\d*)\.
             (?<minor>0|[1-9]\d*)\.
             (?<patch>0|[1-9]\d*)
             (-(?<prerelease>[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?
             (\+(?<build>[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?
             $
             """x

  @type t :: %Semver{major: integer, minor: integer, patch: integer, prerelease: [String.t], build: [String.t]}
  defstruct major: 0, minor: 0, patch: 0, prerelease: [], build: []

  @doc """
  Gets the version string of the module.
  """
  @spec version() :: String.t
  def version, do: @vsn

  @doc """
  Increment the named `part` of `version`.
  """
  @spec increment(String.t, atom) :: String.t
  @spec increment(t, atom) :: t
  def increment(version, part) when is_binary(version) do
    version
    |> Semver.parse!
    |> Semver.increment(part)
    |> Semver.to_string
  end

  def increment(version, :major) do
    %Semver{version | major: version.major + 1, minor: 0, patch: 0, prerelease: [], build: []}
  end

  def increment(version, :minor) do
    %Semver{version | minor: version.minor + 1, patch: 0, prerelease: [], build: []}
  end

  def increment(version, :patch) do
    %Semver{version | patch: version.patch + 1, prerelease: [], build: []}
  end

  @doc """
  Validates that `version` is a valid Semver string.
  """
  @spec is_valid(String.t) :: boolean
  def is_valid(version), do: version =~ @pattern

  @doc """
  Parses `version` into a `Semver` struct.
  """
  @spec parse(String.t) :: {:ok, t} | {:error, :invalid}
  def parse(version) do
    cond do
      is_valid(version) -> parse_valid(version)
      true -> {:error, :invalid}
    end
  end

  @doc """
  Parses a version string into a `Semver` struct. If `version` is not a valid version string, it
  raises `Semver.Error`.
  """
  @spec parse!(String.t) :: t | no_return
  def parse!(version) do
    case parse(version) do
      {:ok, retval} -> retval
      {:error, :invalid} -> raise Semver.Error, message: "Invalid version text: #{version}"
    end
  end

  @doc """
  Converts the `version` struct into a version string.
  """
  @spec to_string(t) :: String.t
  def to_string(version) do
    "#{version.major}.#{version.minor}.#{version.patch}"
    |> append_prerelease(version)
    |> append_build(version)
  end

  defp append_build(text, %{build: []}), do: text
  defp append_build(text, %{build: list}), do: "#{text}+#{Enum.join(list, ".")}"

  defp append_prerelease(text, %{prerelease: []}), do: text
  defp append_prerelease(text, %{prerelease: list}), do: "#{text}-#{Enum.join(list, ".")}"

  defp correct_list([""]), do: []
  defp correct_list(list), do: list

  defp extract_integer(text) do
    {number, _} = Integer.parse(text)
    number
  end

  defp parse_valid(version) do
    parts = Regex.named_captures(@pattern, version)
    major = extract_integer(parts["major"])
    minor = extract_integer(parts["minor"])
    patch = extract_integer(parts["patch"])
    prerelease = correct_list(String.split(parts["prerelease"], ~r/\./))
    build = correct_list(String.split(parts["build"], ~r/\./))

    {:ok, %Semver{major: major, minor: minor, patch: patch, prerelease: prerelease, build: build}}
  end
end
