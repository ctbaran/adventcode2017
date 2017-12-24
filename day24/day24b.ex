defmodule Day24B do

  def solve(input) do

    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.map(&to_connector/1)
    |> Enum.to_list
    |> get_bridges
    |> List.flatten
    |> Enum.sort(fn {strength1, _length1},{strength2, _length2} -> strength1 >= strength2 end)
    |> Enum.max_by(fn {_strength, length} -> length end)
  end

  def to_connector(string) do
    [p1, p2] = String.split(string, "/")
    {String.to_integer(p1), String.to_integer(p2)}
  end

  def get_bridges(connectors) do
    Enum.filter(connectors, fn {x,y} -> x == 0 || y == 0 end)
    |> Enum.map(fn x -> bridge_from(x, opp_port(x, 0), List.delete(connectors, x), [x]) end)
  end

  def bridge_from({p1, _p2}, p1, connectors, bridge) do
    if Enum.filter(connectors, fn {x,y} -> x == p1 || y == p1 end) |> Enum.any? do
      Enum.filter(connectors, fn {x,y} -> x == p1 || y == p1 end)
      |> Enum.map(fn x -> bridge_from(x, opp_port(x, p1), List.delete(connectors, x), [x|bridge]) end)
    else
      {sum_bridge(bridge, 0), Enum.count(bridge)}
    end
  end
  def bridge_from({_p1, p2}, p2, connectors, bridge) do
    if Enum.filter(connectors, fn {x,y} -> x == p2 || y == p2 end) |> Enum.any? do
      Enum.filter(connectors, fn {x,y} -> x == p2 || y == p2 end)
      |> Enum.map(fn x -> bridge_from(x, opp_port(x, p2), List.delete(connectors, x), [x|bridge]) end)
    else
      {sum_bridge(bridge, 0), Enum.count(bridge)}
    end
  end

  def opp_port({port, p2}, port), do: p2
  def opp_port({p1, port}, port), do: p1

  def sum_bridge([], sum), do: sum
  def sum_bridge([{p1, p2}|rest], sum), do: sum_bridge(rest, sum + p1 + p2)
end