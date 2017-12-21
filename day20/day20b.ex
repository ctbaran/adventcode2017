defmodule Day20B do

  def solve(input) do
    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.with_index
    |> Stream.map(&to_particle/1)
    |> Enum.to_list
    |> Stream.iterate(&update_particles/1)
    |> Enum.at(10000)
    |> Enum.count
  end

  def to_particle({string, num}) do
    [_, x_p,y_p,z_p,x_v,y_v,z_v,x_a,y_a,z_a] = Regex.run(~r/p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/, string)
    {num, {to_i(x_p,y_p,z_p), to_i(x_v,y_v,z_v), to_i(x_a,y_a,z_a)}}
  end

  def manhattan_distance({x,y,z}) do
    abs(x) + abs(y) + abs(z)
  end

  def to_i(x,y,z), do: {String.to_integer(x),String.to_integer(y),String.to_integer(z)}

  def update_particles(particles) do
    Enum.map(particles, &update_particle/1)
    |> Enum.group_by(fn {_, {pos, _, _}} -> pos end)
    |> Map.to_list
    |> Enum.filter(fn {_, list} -> Enum.count(list) == 1 end)
    |> Enum.flat_map(fn {_, part} -> part end)
  end

  def update_particle({num, {{xp, yp, zp}, {xv, yv, zv}, {xa, ya, za}}}) do
    {nxv, nyv, nzv} = {xv + xa, yv + ya, zv + za}
    {nxp, nyp, nzp}  = {xp + nxv, yp + nyv, zp + nzv}
    {num, {{nxp, nyp, nzp}, {nxv, nyv, nzv}, {xa, ya, za}}}
  end
end

