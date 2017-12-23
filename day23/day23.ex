defmodule Day23 do

  def solve(input) do
    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.map(&get_instruction/1)
    |> Stream.with_index
    |> Enum.reduce(Map.new, fn {instruction, index}, acc -> Map.put(acc, index, instruction) end)
    |> evaluate(0, init_registers(), 0)
  end

  def init_registers() do 
    Enum.reduce(?a..?h |> Enum.to_list,
                Map.new,
                fn reg, set -> Map.put(set, reg, 0) end)
  end

  def get_instruction("set " <> <<x>> <> " " <> y), do: {:set, x, reg_or_num(y)}
  def get_instruction("sub " <> <<x>> <> " " <> y), do: {:sub, x, reg_or_num(y)}
  def get_instruction("mul " <> <<x>> <> " " <> y), do: {:mul, x, reg_or_num(y)}
  def get_instruction("jnz " <> rest) do
    [x, y] = String.split(rest, " ")
    case Integer.parse(x) do
      :error -> {:jnz, hd(String.to_charlist(x)), reg_or_num(y)}
      {num,_} -> {:jnz, num, reg_or_num(y)}
    end
  end
 
  def reg_or_num(val) do
    case Integer.parse(val) do
      :error -> {:reg, val}
      {num,_} -> num
    end
  end

  def get_val(registers, {:reg, <<val>>}), do: Map.get(registers, val)
  def get_val(_registers, val), do: val 

  def evaluate(_instruction_set, current_instruction, _registers, mul_count) when current_instruction < 0, do: mul_count
  def evaluate(instruction_set, current_instruction, registers, mul_count) do
    if current_instruction > (Map.keys(instruction_set) |> Enum.count) - 1 do
      mul_count
    else
      eval(Map.get(instruction_set, current_instruction), instruction_set, current_instruction, registers, mul_count)
    end
  end

  def eval({:set, x, y}, instruction_set, current_instruction, registers, mul_count) do 
    evaluate(instruction_set, current_instruction + 1, Map.put(registers, x, get_val(registers, y)), mul_count)
  end
  def eval({:sub, x, y}, instruction_set, current_instruction, registers, mul_count) do
    evaluate(instruction_set, current_instruction + 1, Map.update!(registers, x, fn val -> val - get_val(registers, y) end), mul_count)
  end 
  def eval({:mul, x, y}, instruction_set, current_instruction, registers, mul_count) do
    evaluate(instruction_set, current_instruction + 1, Map.update!(registers, x, fn val -> val * get_val(registers, y) end), mul_count+1)
  end 
  def eval({:jnz, x, y}, instruction_set, current_instruction, registers, mul_count) do 
    if Map.get(registers, get_val(registers,x)) != 0 do
      evaluate(instruction_set, current_instruction + get_val(registers, y), registers, mul_count)
    else
      evaluate(instruction_set, current_instruction + 1, registers, mul_count)
    end
  end 
end