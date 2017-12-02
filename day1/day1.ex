defmodule Day1 do
  def solve("") do
    0
  end

  def solve(<<a>> <> rest) do
    solve_helper(a, rest, a, 0)
  end

  def solve_helper(a, "", a, n) do
    n + get_int(<<a>>)
  end

  def solve_helper(_, "", _, n) do
    n
  end

  def solve_helper(a, <<a>> <> rest, first, n) do
    solve_helper(a, rest, first, n + get_int(<<a>>))
  end

  def solve_helper(_, <<a>> <> rest, first, n) do
    solve_helper(a, rest, first, n)
  end

  def get_int(n) do
    {int, _} = Integer.parse(n)
    int
  end
end 