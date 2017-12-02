defmodule Day1B do
  def solve("") do
    0
  end

  def solve(captcha) do
    solve_helper(String.first(captcha), rest(captcha), 0, String.length(captcha))
  end

  def solve_helper(_, _, n, 0) do
    n
  end
 
  def solve_helper(first, captcha, n, steps) do
    next = rest(captcha) <> first
    if first == half(captcha) do
      solve_helper(String.first(captcha), next, n + get_int(first), steps - 1)
    else 
      solve_helper(String.first(captcha), next, n, steps - 1)  
    end
  end

  def get_int(n) do
    {int, _} = Integer.parse(n)
    int
  end

  def rest(string) do
    String.slice(string, 1, String.length(string)-1)
  end

  def half(string) do
    String.at(string, div(String.length(string), 2))
  end
end 