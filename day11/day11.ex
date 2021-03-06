defmodule Day11 do
  def solve(input) do
    File.read!(input) 
    |> String.strip 
    |> String.split(",")
    |> Enum.reduce({0,0,0}, fn dir,pos -> move(dir,pos) end)
    |> find_distance
  end

  def move("nw", {x,y,z}), do: {x+1,y-1,z}
  def move("n", {x,y,z}), do: {x,y-1,z+1}
  def move("ne", {x,y,z}), do: {x-1,y,z+1}
  def move("sw", {x,y,z}), do: {x+1,y,z-1}
  def move("s", {x,y,z}), do: {x,y+1,z-1}
  def move("se", {x,y,z}), do: {x-1,y+1,z}

  def find_distance({x,y,z}), do: div(abs(x) + abs(y) + abs(z), 2)

end