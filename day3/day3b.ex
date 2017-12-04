defmodule Day3B do
  def solve(1) do
    1
  end

  def solve(up_to) do
    values = %{{0,0} => 1}
    get_above(values, 2, up_to)
  end

  def get_above(values, pos, up_to) do
    {coords, value} = get_coords_and_value(pos, values)
    if value > up_to do
      value 
    else
      get_above(Map.put(values, coords, value), pos+1, up_to)
    end
  end


  def get_coords_and_value(pos, map) do
    ring = get_ring(pos)
    inner_area = sq(((ring-1) * 2) -1) 
    relative_pos = pos - inner_area - 1
    quadrant = div(relative_pos, 2*(ring-1))
    dist_along = relative_pos - (quadrant * (ring-1) * 2)
    coords = map_coords(quadrant, ring, dist_along)
    {coords, get_value(coords, map)}
  end

  def map_coords(quadrant, ring, dist_along) do
    case quadrant do
      0 -> {ring - 1, 2 - ring + dist_along}
      1 -> {ring - 2 - dist_along, ring - 1}
      2 -> {-(ring - 1), ring - 2 - dist_along}
      3 -> {-(ring - 2) + dist_along,-(ring - 1)}
    end
  end

  def get_value({p, q}, values) do
    Map.get(values, {p, q+1}, 0) + Map.get(values, {p, q-1}, 0) + Map.get(values, {p+1, q}, 0) + Map.get(values, {p-1, q}, 0) + 
    Map.get(values, {p-1, q-1}, 0) + Map.get(values, {p+1, q-1}, 0) + Map.get(values, {p+1, q+1}, 0) + Map.get(values, {p-1, q+1}, 0)
  end

  def get_ring(pos) do
    diameter = Stream.iterate(1, &(&1+2))
                |> Stream.filter(&(div(&1*&1, pos) >= 1))
                |> Enum.at(0)
    diameter - div(diameter, 2)
  end

  def sq(x) do
    x * x
  end

  def is_diagonal({p, q}, ring) do
    abs(p) + abs(q) == (ring-1) * 2
  end
end