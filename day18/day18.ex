defmodule Day18 do

  def solve(input) do
    {_, instruction_set} = File.stream!(input)
                           |> Stream.map(&String.strip/1)
                           |> Stream.map(&get_instruction/1)
                           |> Enum.reduce({0, Map.new}, fn instruction, {index, acc} -> {index+1, Map.put(acc, index, instruction)} end)
    
    evaluate(instruction_set, 0, init_registers(), 0)
  end

  def init_registers() do 
    Enum.reduce(?a..?z |> Enum.to_list,
                Map.new,
                fn reg, set -> Map.put(set, reg, 0) end)
  end

  def get_instruction("snd " <> x), do: {:snd, x}
  def get_instruction("rcv " <> x), do: {:rcv, x}
  def get_instruction("set " <> <<x>> <> " " <> y), do: {:set, x, reg_or_num(y)}
  def get_instruction("add " <> <<x>> <> " " <> y), do: {:add, x, reg_or_num(y)}
  def get_instruction("mul " <> <<x>> <> " " <> y), do: {:mul, x, reg_or_num(y)}
  def get_instruction("mod " <> <<x>> <> " " <> y), do: {:mod, x, reg_or_num(y)}
  def get_instruction("jgz " <> <<x>> <> " " <> y), do: {:jgz, x, reg_or_num(y)}
 
  def reg_or_num(val) do
    case Integer.parse(val) do
      :error -> {:reg, val}
      {num,_} -> num
    end
  end

  def get_val(registers, {:reg, <<val>>}), do: Map.get(registers, val)
  def get_val(_registers, val), do: val 

  def evaluate(_instruction_set, current_instruction, _registers, _snd) when current_instruction < 0, do: :no_rcv
  def evaluate(instruction_set, current_instruction, registers, snd) do
    if current_instruction >= (Map.keys(instruction_set) |> Enum.count) - 1 do
      :no_rcv
    else
      eval(Map.get(instruction_set, current_instruction), instruction_set, current_instruction, registers, snd)
    end
  end


  def eval({:snd, x}, instruction_set, current_instruction, registers, _snd) do 
    evaluate(instruction_set, current_instruction + 1, registers, get_val(registers, {:reg, x}))
  end
  def eval({:set, x, y}, instruction_set, current_instruction, registers, snd) do 
    evaluate(instruction_set, current_instruction + 1, Map.put(registers, x, get_val(registers, y)), snd)
  end
  def eval({:rcv, x}, instruction_set, current_instruction, registers, snd) do 
    if Map.get(registers, x) > 0, do: snd, else: evaluate(instruction_set, current_instruction + 1, registers, snd)
  end 
  def eval({:add, x, y}, instruction_set, current_instruction, registers, snd) do 
    evaluate(instruction_set, current_instruction+1, Map.update!(registers, x, fn val -> val + get_val(registers, y) end), snd)
  end
  def eval({:mul, x, y}, instruction_set, current_instruction, registers, snd) do
    evaluate(instruction_set, current_instruction+1, Map.update!(registers, x, fn val -> val * get_val(registers, y) end), snd)
  end 
  def eval({:mod, x, y}, instruction_set, current_instruction, registers, snd) do 
    evaluate(instruction_set, current_instruction+1, Map.update!(registers, x, fn val -> rem(val, get_val(registers, y)) end), snd)
  end 
  def eval({:jgz, x, y}, instruction_set, current_instruction, registers, snd) do 
    if Map.get(registers, x) > 0 do
      evaluate(instruction_set, current_instruction + get_val(registers, y), registers, snd)
    else
      evaluate(instruction_set, current_instruction + 1, registers, snd)
    end
  end 
end
