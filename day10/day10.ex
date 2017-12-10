defmodule Day10 do
  @list_size 256
  
  def solve(input) do
    starting_list = init_list(@list_size)
    {_, _, cycled_list} = Enum.reduce(File.read!(input) |> String.strip |> String.split(",") |> Enum.map(&String.to_integer/1),
                                       {0, 0, starting_list},
                                       &do_iteration/2)
    
    Map.get(cycled_list, 0) * Map.get(cycled_list, 1)
  end

  def init_list(size) do
    Enum.reduce(0..size-1, Map.new, fn x, map -> Map.put(map, x, x) end)
  end

  def do_iteration(reverse_length, {starting_point, skip_size, list}) do
    cycled_list = reverse_sublist(starting_point, starting_point+reverse_length-1, list)
    new_starting_point = rem(starting_point + reverse_length + skip_size, @list_size)
    {new_starting_point, skip_size + 1, cycled_list}
  end

  def reverse_sublist(front, back, list) when front >= back, do: list
  def reverse_sublist(front, back, list), do: reverse_sublist(front+1, back-1, swap(front, back, list))

  def swap(a, b, map) do
    tmp = Map.get(map, normalize(a))
    partial_swap = Map.put(map, normalize(a), Map.get(map, normalize(b)))
    Map.put(partial_swap, normalize(b), tmp)
  end

  def normalize(x), do: rem(x, @list_size)
end