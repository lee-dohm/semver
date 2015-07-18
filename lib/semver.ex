defmodule Semver do
  @moduledoc """
  Utilities for working with [Semver-compliant](http://semver.org) version strings.
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

  defstruct major: 0, minor: 0, patch: 0, prerelease: [], build: []

  @doc """
  Module version.
  """
  def version, do: @vsn

  @doc """
  Validates that `version` is a valid Semver string.
  """
  def is_valid(version) do
    version =~ @pattern
  end

  @doc """
  Parses `version` into a `Semver` struct.
  """
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
  def parse!(version) do
    case parse(version) do
      {:ok, retval} -> retval
      {:error, :invalid} -> raise Semver.Error, message: "Invalid version text: #{version}"
    end
  end

  @doc """
  Converts a `Semver` struct into a version string.
  """
  def to_string(struct) do
    "#{struct.major}.#{struct.minor}.#{struct.patch}"
    |> append_prerelease(struct)
    |> append_build(struct)
  end

  defp append_build(text, []), do: text
  defp append_build(text, %{prerelease: list}), do: "#{text}+#{Enum.join(list, ".")}"

  defp append_prerelease(text, []), do: text
  defp append_prerelease(text, %{build: list}), do: "#{text}-#{Enum.join(list, ".")}"

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
