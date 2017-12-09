defmodule Day9B do

  def solve(input) do
    get_groups(File.read!(input), false, 0)
  end

  def get_groups(<<>>, _in_garbage, uncancelled), do: uncancelled
  def get_groups("!" <> rest, in_garbage, uncancelled), do: get_groups(String.slice(rest, 1, String.length(rest)), in_garbage, uncancelled)
  def get_groups("<" <> rest, false, uncancelled), do: get_groups(rest, true, uncancelled)
  def get_groups(">" <> rest, true, uncancelled), do: get_groups(rest, false, uncancelled)
  def get_groups(anything, true, uncancelled), do: get_groups(String.slice(anything, 1, String.length(anything)), true, uncancelled + 1)
  def get_groups(anything, in_garbage, uncancelled), do: get_groups(String.slice(anything, 1, String.length(anything)), in_garbage, uncancelled)

end