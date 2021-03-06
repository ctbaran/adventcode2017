defmodule Day6B do
  def solve(file) do
    File.read!(file)
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({0, Map.new}, fn blocks, {max_offset, banks} -> {max_offset + 1, Map.put(banks, max_offset, blocks)} end)
    |> redistribute
  end

  def redistribute({max_offset, banks}) do
    redistribute({max_offset, banks}, MapSet.new([banks]))
  end

  def redistribute({max_offset, banks}, already_seen) do
    bank = get_max_bank(banks)

    redistributed = cycle(max_offset, Map.put(banks, bank, 0), Map.get(banks, bank), bank+1)

    if MapSet.member?(already_seen, redistributed) do
      calculate_loop({max_offset, redistributed}, redistributed, 0)
    else
      redistribute({max_offset, redistributed}, MapSet.put(already_seen, redistributed))
    end
  end

  def calculate_loop({max_offset, banks}, start_point, steps) do
    bank = get_max_bank(banks)
    redistributed = cycle(max_offset, Map.put(banks, bank, 0), Map.get(banks, bank), bank+1)

    if Map.equal?(start_point, redistributed) do
      steps + 1
    else
      calculate_loop({max_offset, redistributed}, start_point, steps+1)
    end
  end

  def cycle(_, banks, 0, _) do
    banks
  end

  def cycle(max_offset, banks, blocks, next_bank) do
    cycle(max_offset, Map.update!(banks, rem(next_bank, max_offset), fn x -> x + 1 end), blocks - 1, next_bank + 1)
  end

  def get_max_bank(banks) do
    {_, max} = Map.to_list(banks)
          |> Enum.max_by(fn {_,n} -> n end)

    {bank,_} = Map.to_list(banks) |> Enum.filter(fn {_, x} -> x == max end) |> Enum.sort |> Enum.at(0)
    bank
  end

end