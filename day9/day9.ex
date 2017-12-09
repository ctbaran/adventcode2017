defmodule Day9 do

  def solve(input) do
    get_groups(File.read!(input), false, 0, 0)
  end

  def get_groups(<<>>, _in_garbage, _depth, total), do: total
  def get_groups("!" <> rest, in_garbage, depth, total), do: get_groups(String.slice(rest, 1, String.length(rest)), in_garbage, depth, total)
  def get_groups("<" <> rest, _in_garbage, depth, total), do: get_groups(rest, true, depth, total)
  def get_groups(">" <> rest, true, depth, total), do: get_groups(rest, false, depth, total)
  def get_groups("{" <> rest, false, depth, total), do: get_groups(rest, false, depth + 1, total)
  def get_groups("}" <> rest, false, depth, total), do: get_groups(rest, false, depth - 1, total + depth)
  def get_groups("," <> rest, false, depth, total), do: get_groups(rest, false, depth, total)
  def get_groups(garbage, true, depth, total), do: get_groups(String.slice(garbage, 1, String.length(garbage)), true, depth, total)

end