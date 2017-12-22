defmodule Day22B do

  def solve(input, iterations) do
    grid = File.stream!(input)
           |> Stream.map(&String.strip/1)
           |> Stream.map(&String.to_charlist/1)
           |> Stream.with_index
           |> Stream.flat_map(fn {line, y} -> Enum.with_index(line) |> Enum.map(fn {char, x} -> {{x, y}, to_sym(char)} end) end)
           |> Enum.reduce(Map.new, fn {coords, state}, acc -> Map.put(acc, coords, state) end)

    start_navigate(grid, iterations)
  end

  def to_sym(?#), do: :infected
  def to_sym(?.), do: :clean

  def get_start(map) do
    keys = Map.keys(map)
    {max_x, _} = Enum.max_by(keys, fn {x, _} -> x end)
    {_, max_y} = Enum.max_by(keys, fn {_, y} -> y end)

    {div(max_x, 2), div(max_y, 2)}
  end

  def start_navigate(grid, 0), do: grid
  def start_navigate(grid, iterations) do
    {x, y} = get_start(grid)

    if Map.get(grid, {x,y}) == :clean do
      navigate(Map.put(grid, {x,y}, :weakened), {x-1, y}, :left, iterations-1, 0)
    else
      navigate(Map.put(grid, {x,y}, :flagged), {x+1, y}, :right, iterations-1, 0) 
    end
  end

  def navigate(_grid, _coord, _direction, 0, infected), do: infected
  def navigate(grid, coord, direction, iterations, infected) do
    case Map.get(grid, coord, :clean) do
      :clean ->
        new_dir = next_dir(:clean, direction)
        new_coord = next_coord(coord, new_dir)
        navigate(Map.put(grid, coord, :weakened), new_coord, new_dir, iterations-1, infected)
      :infected ->
        new_dir = next_dir(:infected, direction)
        new_coord = next_coord(coord, new_dir)
        navigate(Map.put(grid, coord, :flagged), new_coord, new_dir, iterations-1, infected)
      :weakened ->
        new_coord = next_coord(coord, direction)
        navigate(Map.put(grid, coord, :infected), new_coord, direction, iterations-1, infected+1)
      :flagged ->
        new_dir = next_dir(:flagged, direction)
        new_coord = next_coord(coord, new_dir)
        navigate(Map.put(grid, coord, :clean), new_coord, new_dir, iterations-1, infected)
    end
  end

  def next_dir(:clean, :left), do: :down
  def next_dir(:clean, :up), do: :left
  def next_dir(:clean, :right), do: :up
  def next_dir(:clean, :down), do: :right
  def next_dir(:infected, :left), do: :up
  def next_dir(:infected, :up), do: :right
  def next_dir(:infected, :right), do: :down
  def next_dir(:infected, :down), do: :left
  def next_dir(:flagged, :left), do: :right
  def next_dir(:flagged, :up), do: :down
  def next_dir(:flagged, :right), do: :left
  def next_dir(:flagged, :down), do: :up

  def next_coord({x, y}, :left), do: {x-1, y}
  def next_coord({x, y}, :right), do: {x+1, y}
  def next_coord({x, y}, :up), do: {x, y-1}
  def next_coord({x, y}, :down), do: {x, y+1}
end