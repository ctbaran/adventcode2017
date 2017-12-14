defmodule Day13B do

  def solve(input) do
    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn x -> [depth, range] = String.split(x, ": "); {String.to_integer(depth), String.to_integer(range)} end)
    |> Enum.reduce(Map.new, fn {depth, range}, acc -> Map.put(acc, depth, {range, 0}) end)
    |> delay_traverse(0)
  end

  def delay_traverse(firewall, delay) do
    if traverse(firewall) do
      delay
    else
      delay_traverse(move_scanners(firewall), delay + 1)
    end
  end

  def traverse(firewall), do: traverse(firewall, Enum.max(Map.keys(firewall)), 0, true)
  def traverse(firewall, max_position, max_position, true), do: is_safe(firewall, max_position)
  def traverse(_firewall, _max_position, _position, false), do: false
  def traverse(firewall, max_position, position, true) do 
    traverse(move_scanners(firewall), 
             max_position, 
             position + 1, 
             is_safe(firewall, position))
  end

  def move_scanners(firewall) do
    Enum.reduce(Map.to_list(firewall), 
                firewall, 
                fn {depth, {range, cur}}, acc -> Map.put(acc, depth, {range, rem(cur+1,(range-1)*2)}) end)
  end

  def is_safe(firewall, position) do 
    {_, cur} = Map.get(firewall, position, {0,-1})
    if cur == 0 do
      false
    else
      true
    end
  end

end