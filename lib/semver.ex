defmodule Semver do
  @moduledoc """
  Utilities for working with semver-compliant version strings.
  """

  @doc """
  Validates a version string.
  """
  def valid?(version) do
    version =~ ~r/^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$/
  end

  def split(version) do
    [major_text, minor_text, patch_text] = String.split(version, ~r/\./)
    {major, _} = Integer.parse(major_text)
    {minor, _} = Integer.parse(minor_text)
    {patch, _} = Integer.parse(patch_text)

    %{major: major, minor: minor, patch: patch}
  end
end
