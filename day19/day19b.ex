defmodule Day19B do

  def solve(input) do
    coords = File.stream!(input)
             |> Stream.with_index
             |> Stream.flat_map(&to_coords/1)
             |> Enum.to_list

    {start, _} = hd(coords)
    {{max_x, _y}, _} = Enum.max_by(coords, fn {{x,_y}, _char} -> x end)
    {{_x, max_y}, _} = Enum.max_by(coords, fn {{_x,y}, _char} -> y end)
    map = Enum.reduce(coords, Map.new, fn {coords, val}, acc -> Map.put(acc, coords, val) end)
    navigate(map, start, :down, max_x, max_y, 0)
  end

  def to_coords({string, y}) do
    String.to_charlist(string)
    |> Enum.with_index
    |> Enum.map(fn {char, x} -> to_coord({x, y}, char) end)
    |> Enum.filter(fn x -> x != nil end)
  end

  def to_coord(_coords, ?\n), do: nil
  def to_coord(_coords, ?\s), do: nil 
  def to_coord(coords, ?|), do: {coords, ?|}
  def to_coord(coords, ?-), do: {coords, ?-}
  def to_coord(coords, ?+), do: {coords, ?+}
  def to_coord(coords, char), do: {coords, char}

  def navigate(map, current, dir, max_x, max_y, steps) do
    case Map.get(map, current) do
      ?+ -> turn(map, current, dir, max_x, max_y, steps)
      nil -> steps
      _ -> navigate(map, next(current, dir), dir, max_x, max_y, steps + 1)
    end
  end

  def next({x,y}, :right), do: {x+1, y}
  def next({x,y}, :left), do: {x-1, y}
  def next({x,y}, :up), do: {x, y-1}
  def next({x,y}, :down), do: {x, y+1}

  def turn(map, current, dir, max_x, max_y, steps) do
    new_dir = turn_right(dir)
    next_coord = next(current, new_dir)
    case Map.get(map, next_coord) do
      nil -> turn(map, current, turn_left(dir), max_x, max_y, steps)
      _ -> navigate(map, next_coord, new_dir, max_x, max_y, steps + 1)
    end
  end

  def turn_right(:up), do: :right
  def turn_right(:right), do: :down
  def turn_right(:down), do: :left
  def turn_right(:left), do: :up

  def turn_left(:up), do: :left
  def turn_left(:left), do: :down
  def turn_left(:down), do: :right
  def turn_left(:right), do: :up
end
