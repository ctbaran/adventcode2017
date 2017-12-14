defmodule Day13 do

  def solve(input) do
    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn x -> [depth, range] = String.split(x, ": "); {String.to_integer(depth), String.to_integer(range)} end)
    |> Enum.reduce(Map.new, fn {depth, range}, acc -> Map.put(acc, depth, {range, 0}) end)
    |> traverse
  end

  def traverse(firewall), do: traverse(firewall, Enum.max(Map.keys(firewall)), 0, 0)
  def traverse(firewall, max_position, max_position, severity), do: severity + get_severity(firewall, max_position)
  def traverse(firewall, max_position, position, severity) do 
    traverse(move_scanners(firewall), 
             max_position, 
             position + 1, 
             severity + get_severity(firewall, position))
  end

  def move_scanners(firewall) do
    Enum.reduce(Map.to_list(firewall), 
                firewall, 
                fn {depth, {range, cur}}, acc -> Map.put(acc, depth, {range, rem(cur+1,(range-1)*2)}) end)
  end

  def get_severity(firewall, position) do 
    {range, cur} = Map.get(firewall, position, {0,-1})
    if cur == 0 do
      range * position
    else
      0  
    end
  end

end