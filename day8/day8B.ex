defmodule Day8B do
  def solve(file) do
    {registers, highest} = File.stream!(file)
                          |> Stream.map(&String.strip/1)
                          |> Stream.map(&to_instruction/1)
                          |> Enum.reduce({Map.new, 0}, fn instruction, {registers, highest} -> evaluate_instruction(instruction, registers, highest) end)

    highest
  end

  def to_instruction(line) do
    [target_reg, op, value, _, test_reg, comp, test_val] = String.split(line)
    {target_reg, op, String.to_integer(value), test_reg, comp, String.to_integer(test_val)}
  end

  def evaluate_instruction({target_reg, op, op_value, test_reg, comp, test_val}, registers, highest) do
    if evaluate_comp(test_reg, comp, test_val, registers) do
      val = do_op(op, op_value, Map.get(registers, target_reg, 0))
      new_highest = if val > highest, do: val, else: highest
      {Map.put(registers, target_reg, val), new_highest}
    else
      {registers, highest}
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