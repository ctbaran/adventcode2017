defmodule Day16B do

  def solve(input) do
    instructions = File.read!(input) 
                   |> String.strip
                   |> String.split(",")
                   |> Enum.map(&to_instruction/1)
                   |> Enum.to_list

    factor = factor_transformation('abcdefghijklmnop', 'abcdefghijklmnop', instructions, 0)
    
    Stream.iterate('abcdefghijklmnop', fn x -> apply_transformation(instructions, x) end)
    |> Enum.at(rem(1000000000, factor))
  end

  def to_instruction(<<type>> <> args) do
    case type do
      ?s -> {:s, String.to_integer(args)}
      ?x -> [pos1, pos2] = String.split(args, "/")
            {:x, String.to_integer(pos1), String.to_integer(pos2)}
      ?p -> [program1, program2] = String.split(args, "/")
            {:p, to_charlist(program1), to_charlist(program2)}
    end
  end

  def process_instruction({:s, n}, order) do
    {new_end, new_beginning} = Enum.split(order, 16-n)
    Enum.concat(new_beginning, new_end)
  end

  def process_instruction({:x, pos1, pos2}, order) do
    tmp = Enum.at(order, pos1)
    List.replace_at(order, pos1, Enum.at(order, pos2))
    |> List.replace_at(pos2, tmp)
  end

  def process_instruction({:p, [program1], [program2]}, order) do
    pos1 = Enum.find_index(order, fn x -> x == program1 end)
    pos2 = Enum.find_index(order, fn x -> x == program2 end)
    List.replace_at(order, pos1, program2)
    |> List.replace_at(pos2, program1)
  end

  def apply_transformation(instructions, base) do
    Enum.reduce(instructions, base, fn instruction, acc -> process_instruction(instruction, acc) end)
  end

  def factor_transformation(base, base, _transformation, n) when n > 0, do: n
  def factor_transformation(current, base, transformation, n) do
   factor_transformation(apply_transformation(transformation, current), base, transformation, n + 1)
  end
end