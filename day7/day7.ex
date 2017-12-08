defmodule Day7 do
  def solve(file) do
    tower = File.stream!(file)
            |> Stream.map(&String.strip/1)
            |> Stream.map(&to_instruction/1)
            |> Enum.reduce(Map.new, fn instruction, tower -> add_disc(tower, instruction) end)

    first = hd(Map.keys(tower))
    find_base(tower, first, Map.get(tower, first))
  end

  def to_instruction(line) do
    [disc_weight|discs_above] = String.split(line, " -> ")
    [disc, weight] = String.split(disc_weight)
    above_list = if (discs_above == []), do: [], else: String.split(hd(discs_above), ", ")
    {disc, String.to_integer(String.slice(weight, 1..String.length(weight)-2)), above_list}
  end

  def add_disc(tower, {disc, weight, above}) do
    new_tower = Map.update(tower, disc, {weight, nil, above}, fn {_, disc, _} -> {weight, disc, above} end)

    Enum.reduce(above, new_tower,
      fn above_disc, acc -> Map.update(acc, above_disc, {nil, disc, nil}, fn {weight, _, aboved} -> {weight, disc, above} end) end)
  end

  def find_base(_, disc, {_, nil, _}) do
    disc
  end

  def find_base(tower, disc, {_, below, _}) do
    find_base(tower, below, Map.get(tower, below))
  end

end