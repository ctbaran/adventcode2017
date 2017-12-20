defmodule Day17B do

  def solve(input, cycles) do
    Stream.iterate({1, 0, 1}, fn {current_val, starting_pos, at_position_one} -> get_next_buffer(current_val, starting_pos, at_position_one, input) end)
    |> Enum.at(cycles)
  end

  def get_next_buffer(current_val, current_index, at_position_one, steps) do
    steps_in_buffer = rem(steps, current_val)
    insert_at = rem(current_index + steps_in_buffer, current_val) + 1

    if insert_at == 1 do
      {current_val+1, insert_at, current_val}
    else
      {current_val+1, insert_at, at_position_one}
    end
  end
end