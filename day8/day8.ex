defmodule Day8 do
  def solve(file) do
    registers = File.stream!(file)
                |> Stream.map(&String.strip/1)
                |> Stream.map(&to_instruction/1)
                |> Enum.reduce(Map.new, fn instruction, registers -> evaluate_instruction(instruction, registers) end)

    List.last(List.keysort(Map.to_list(registers),1))
  end

  def to_instruction(line) do
    [target_reg, op, value, _, test_reg, comp, test_val] = String.split(line)
    {target_reg, op, String.to_integer(value), test_reg, comp, String.to_integer(test_val)}
  end

  def evaluate_instruction({target_reg, op, op_value, test_reg, comp, test_val}, registers) do
    if evaluate_comp(test_reg, comp, test_val, registers) do
      Map.update(registers, target_reg, do_op(op, op_value, 0), fn value -> do_op(op, op_value, value) end)
    else
      registers
    end
  end

  def evaluate_comp(test_reg, comp, test_val, registers) do
    val = Map.get(registers, test_reg, 0)
    cond do
      comp == ">" -> val > test_val
      comp == ">=" -> val >= test_val
      comp == "<" -> val < test_val
      comp == "<=" -> val <= test_val
      comp == "==" -> val == test_val
      comp == "!=" -> val != test_val
    end
  end

  def do_op("inc", inc_value, value) do
    value + inc_value
  end

  def do_op("dec", dec_value, value) do
    value - dec_value
  end

end