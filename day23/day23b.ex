defmodule Day23B do

  # 106500, 123500
  def solve(start_num) do
    primes = primes(3, start_num + 17000, MapSet.put(MapSet.new, 2))

    Stream.iterate(start_num, &(&1 + 17))
    |> Stream.take(1001)
    |> Stream.filter(fn x -> !MapSet.member?(primes, x) end)
    |> Enum.count
  end

  # super-naive, I'm lazy
  def primes(num, up_to, primes) when num > up_to, do: primes
  def primes(num, up_to, primes) do
    if Enum.any?(MapSet.to_list(primes), fn x -> rem(num, x) == 0 end) do
      primes(num+1, up_to, primes)
    else
      primes(num+1, up_to, MapSet.put(primes, num))
    end
  end
end