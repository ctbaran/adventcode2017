defmodule Day7B do
  def solve(file) do
    tower = File.stream!(file)
            |> Stream.map(&String.strip/1)
            |> Stream.map(&to_instruction/1)
            |> Enum.reduce(Map.new, fn instruction, tower -> add_disc(tower, instruction) end)

    first = hd(Map.keys(tower))
    base = find_base(tower, first, Map.get(tower, first))
    {_, memoized_tower} = memoize_tower(tower, base, Map.get(tower, base))
    find_unbalanced(memoized_tower, base, Map.get(memoized_tower, base), 0) # starting disc can't be unbalanced so just a filler
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
      fn above_disc, acc -> Map.update(acc, above_disc, {nil, disc, nil}, fn {weight, _, above} -> {weight, disc, above} end) end)
  end

  def memoize_tower(tower, disc, {weight, below, []}) do
    {weight, Map.put(tower, disc, {weight, weight, below, []})}
  end

  def memoize_tower(tower, disc, {weight, _, above}) do
    {sum_weights, memoized_tower} = Enum.reduce(above, {0, tower}, &update_tower/2)
    total_weight = sum_weights + weight
    {total_weight, Map.update!(memoized_tower, disc, 
      fn {weight, below, above} -> {weight, total_weight, below, above} end)}
  end

  def update_tower(disc, {weights, tower}) do
    {total_weight, memoized_tower} = memoize_tower(tower, disc, Map.get(tower, disc))
    {weights + total_weight, memoized_tower}
  end

  def find_unbalanced(_, _, {weight, _, _, []}, target) do
    abs(target - weight)
  end

  def find_unbalanced(tower, _, {weight, _, _, above}, target) do
    sums = Enum.group_by(above, fn key -> get_sum(tower, key) end)
    if Enum.count(Map.keys(sums)) == 1 do
      abs(target - (hd(Map.keys(sums)) * Enum.count(above)))
    else
      [{_, [unbalanced]}, {new_target, _}] = Enum.sort_by(Map.to_list(sums), fn {_,list} -> Enum.count(list) end)
      find_unbalanced(tower, unbalanced, Map.get(tower, unbalanced), new_target)
    end
  end

  def get_sum(tower, disc) do
    {_,total_weight,_,_} = Map.get(tower, disc)
    total_weight
  end

  def find_base(_, disc, {_, nil, _}) do
    disc
  end

  def find_base(tower, _, {_, below, _}) do
    find_base(tower, below, Map.get(tower, below))
  end
end