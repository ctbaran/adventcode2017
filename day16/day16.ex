defmodule Day16 do

  def solve(input) do
    File.read!(input) 
    |> String.strip
    |> String.split(",")
    |> Enum.map(&to_instruction/1)
    |> Enum.reduce("abcdefghijklmnop", &process_instruction/2)
    |> to_string
  end

  def to_instruction(<<type>> <> args) do
    case type do
      ?s -> {:s, String.to_integer(args)}
      ?x -> [pos1, pos2] = String.split(args, "/")
            {:x, String.to_integer(pos1), String.to_integer(pos2)}
      ?p -> [program1, program2] = String.split(args, "/")
            {:p, program1, program2}
    end
  end

  def process_instruction({:s, n}, order) do
    {new_end, new_beginning} = String.split_at(order, -n)
    new_beginning <> new_end
  end

  def process_instruction({:x, pos1, pos2}, order) when pos2 < pos1, do: process_instruction({:x, pos2, pos1}, order)
  def process_instruction({:x, pos1, pos2}, order) do
    first_char = String.at(order, pos1)
    second_char = String.at(order, pos2)

    String.replace(order, second_char, first_char)
    |> String.replace(first_char, second_char, global: false)
  end

  def process_instruction({:p, program1, program2}, order) do
    {pos1, _ } = :binary.match(order, program1)
    {pos2, _ } = :binary.match(order, program2)
    process_instruction({:x, pos1, pos2}, order)
  end
end