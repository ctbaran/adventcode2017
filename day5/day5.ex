defmodule Day5 do
  def solve(file) do
    {max_offset, jumps} = File.stream!(file)
                          |> Stream.map(&get_int/1)
                          |> Enum.reduce({0, Map.new}, fn offset, {max_offset, jumps} -> {max_offset + 1, Map.put(jumps, max_offset, offset)} end)
    evaluate_jumps(0, jumps, max_offset, 0)
  end


  def evaluate_jumps(offset, _, max_offset, steps) when offset >= max_offset do
    steps
  end

  def evaluate_jumps(offset, jumps, max_offset, steps) do
    jump_to = Map.get(jumps, offset)
    evaluate_jumps(offset + jump_to, Map.put(jumps, offset, jump_to + 1), max_offset, steps+1)
  end

  def get_int(n) do
    {int, _} = Integer.parse(n)
    int
  end

end