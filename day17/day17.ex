defmodule Day17 do

  def solve(input) do
    {_, look_at, buffer} = Stream.iterate({1, 0, [0]}, fn {current_val, starting_pos, buffer} -> get_next_buffer(current_val, starting_pos, buffer, input) end)
                         |> Enum.at(2017)

    Enum.at(buffer, look_at+1)
  end

  def get_next_buffer(current_val, starting_pos, buffer, steps) do
    {new_end, new_begin} = Enum.split(buffer, starting_pos)

    insert_after = spin(Enum.concat(new_begin, new_end), steps)
    insert_at = Enum.find_index(buffer, fn x -> x == insert_after end) + 1

    {current_val+1, insert_at, List.insert_at(buffer, insert_at, current_val)}
  end

  def spin(list, steps) do
    Stream.cycle(list)
    |> Enum.at(steps)
  end
end