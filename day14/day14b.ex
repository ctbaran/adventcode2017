defmodule Day14B do
  use Bitwise

  @list_size 256
  @xor_blocks 16

  def solve(input) do
    digraph = :digraph.new

    Enum.map(0..127, fn n -> knot_hash(input <> "-#{n}") end)
    |> Enum.with_index
    |> Enum.each(fn {hash, row} -> link_seq(hash, row, 0, digraph) end)

    Enum.count(:digraph_utils.strong_components(digraph))
  end

  def link_seq([], _row, _column, digraph), do: digraph
  def link_seq([?0|rest], row, column, digraph), do: link_seq(rest, row, column+1, digraph)
  def link_seq([?1|rest], row, column, digraph) do 
    :digraph.add_vertex(digraph, {row, column})
    link_backwards(row, column, digraph)

    link_seq(rest, row, column+1, digraph)
  end

  def link_backwards(row, column, digraph) do
    :digraph.add_edge(digraph, {row,column}, {row, column-1})
    :digraph.add_edge(digraph, {row, column-1}, {row,column})

    :digraph.add_edge(digraph, {row,column}, {row-1, column})
    :digraph.add_edge(digraph, {row-1, column}, {row,column})
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
    |> to_charlist
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
    |> String.rjust(8, ?0)
  end

end