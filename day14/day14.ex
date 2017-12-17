defmodule Day14 do
  use Bitwise

  @list_size 256
  @xor_blocks 16

  def solve(input) do
    Enum.reduce(0..127, 0, fn n, count -> count_ones(input <> "-#{n}", count) end)
  end

  def count_ones(string, count) do
    ones = knot_hash(string)
           |> to_charlist
           |> Enum.filter(fn x -> x == ?1 end)
           |> Enum.count

    ones + count
  end

  def knot_hash(string) do
    starting_list = init_list(@list_size)
    length_sequence = String.to_charlist(string) ++ [17,31,73,47,23]
    {_, _, cycled_list} = Enum.reduce(0..63,
                                      {0, 0, starting_list},
                                      fn count, acc -> do_round(count, acc, length_sequence) end)
    
    Enum.reduce(0..div(@list_size,@xor_blocks)-1,
                "",
                fn x, str -> str <> xor_sequence(x*@xor_blocks, cycled_list) end) 
  end

  def init_list(size) do
    Enum.reduce(0..size-1, Map.new, fn x, map -> Map.put(map, x, x) end)
  end

  def do_round(_round, current_state, length_sequence) do
    Enum.reduce(length_sequence,
                current_state,
                &do_iteration/2)
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

  def xor_sequence(starting_point, list) do 
    Enum.reduce(starting_point..starting_point+@xor_blocks-1, 0, fn x, acc -> bxor(acc, Map.get(list, x)) end)
    |> Integer.to_charlist(2)
    |> to_string
  end

end