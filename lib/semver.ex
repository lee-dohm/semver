defmodule Semver do
  @moduledoc """
  Utilities for working with semver-compliant version strings.
  """

  @doc """
  Validates a version string.
  """
  def is_valid(version) do
    version =~ ~r/^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$/
  end
end
