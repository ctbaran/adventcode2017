defmodule Day3 do
  def solve(1) do
    0
  end

  def solve(pos) do
    {p,q} = get_coords(pos)
    manhattan_distance(p,q)
  end

  def get_coords(pos) do
    ring = get_ring(pos)
    inner_area = sq(((ring-1) * 2) -1) 
    relative_pos = pos - inner_area - 1
    quadrant = div(relative_pos, 2*(ring-1))
    dist_along = relative_pos - (quadrant * (ring-1) * 2)
    map_coords(quadrant, ring, dist_along)
  end

  def map_coords(quadrant, ring, dist_along) do
    case quadrant do
      0 -> {ring - 1, 2 - ring + dist_along}
      1 -> {ring - 2 - dist_along, ring - 1}
      2 -> {-(ring - 1), ring - 2 - dist_along}
      3 -> {-(ring - 2) + dist_along,-(ring - 1)}
    end
  end

  def get_ring(pos) do
    diameter = Stream.iterate(1, &(&1+2))
                |> Stream.filter(&(div(&1*&1, pos) >= 1))
                |> Enum.at(0)
    diameter - div(diameter, 2)
  end

  def manhattan_distance(p, q) do
    abs(p) + abs(q)
  end

  def sq(x) do
    x * x
  end
end