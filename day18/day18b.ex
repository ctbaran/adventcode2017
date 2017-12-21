defmodule Day18B do

  def solve(input) do
    {_, instruction_set} = File.stream!(input)
                           |> Stream.map(&String.strip/1)
                           |> Stream.map(&get_instruction/1)
                           |> Enum.reduce({0, Map.new}, fn instruction, {index, acc} -> {index+1, Map.put(acc, index, instruction)} end)
    
    parent_pid = self()
    pid_a = spawn(fn -> evaluate(instruction_set, 0, init_registers(0), parent_pid, :a) end)
    pid_b = spawn(fn -> evaluate(instruction_set, 0, init_registers(1), parent_pid, :b) end)

    parent({pid_a, :run, 0, []}, {pid_b, :run, 0, []})
  end

  def parent({_pid_a, :term, _sent_a, _msgs_a}, {_pid_b, :term, sent_b, _msgs_b}), do: {:term_both, sent_b}
  def parent({_pid_a, :rcv, _sent_a, _msgs_a}, {_pid_b, :term, sent_b, []}), do: {:deadlock, sent_b}
  def parent({_pid_a, :term, _sent_a, []}, {_pid_b, :rcv, sent_b, _msgs_b}), do: {:deadlock, sent_b}
  def parent({_pid_a, :rcv, _sent_a, []}, {_pid_b, :rcv, sent_b, []}), do: {:deadlock, sent_b}
  def parent({pid_a, :rcv, sent_a, msgs_a}, {pid_b, state_b, sent_b, [msg|rest]}) do
    send(pid_a, msg)
    parent({pid_a, :run, sent_a, msgs_a}, {pid_b, state_b, sent_b, rest})
  end
  def parent({pid_a, state_a, sent_a, [msg|rest]}, {pid_b, :rcv, sent_b, msgs_b}) do
    send(pid_b, msg)
    parent({pid_a, state_a, sent_a, rest}, {pid_b, :run, sent_b, msgs_b})
  end
  def parent({pid_a, state_a, sent_a, msgs_a}, {pid_b, state_b, sent_b, msgs_b}) do
    receive do
      {:a, :term} -> parent({pid_a, :term, sent_a, msgs_a}, {pid_b, state_b, sent_b, msgs_b})
      {:b, :term} -> parent({pid_a, state_a, sent_a, msgs_a}, {pid_b, :term, sent_b, msgs_b})
      {:a, :rcv} -> parent({pid_a, :rcv, sent_a, msgs_a}, {pid_b, state_b, sent_b, msgs_b})
      {:b, :rcv} -> parent({pid_a, state_a, sent_a, msgs_a}, {pid_b, :rcv, sent_b, msgs_b})
      {:a, val} -> parent({pid_a, :run, sent_a+1, Enum.concat(msgs_a,[val])}, {pid_b, state_b, sent_b, msgs_b})
      {:b, val} -> parent({pid_a, state_a, sent_a, msgs_a}, {pid_b, :run, sent_b+1, Enum.concat(msgs_b,[val])})
    end
  end

  def init_registers(p_value) do 
    Enum.reduce(?a..?z |> Enum.to_list,
                Map.new,
                fn reg, set -> Map.put(set, reg, 0) end)
    |> Map.put(?p, p_value)
  end

  def get_instruction("snd " <> x), do: {:snd, reg_or_num(x)}
  def get_instruction("rcv " <> <<x>>), do: {:rcv, x}
  def get_instruction("set " <> <<x>> <> " " <> y), do: {:set, x, reg_or_num(y)}
  def get_instruction("add " <> <<x>> <> " " <> y), do: {:add, x, reg_or_num(y)}
  def get_instruction("mul " <> <<x>> <> " " <> y), do: {:mul, x, reg_or_num(y)}
  def get_instruction("mod " <> <<x>> <> " " <> y), do: {:mod, x, reg_or_num(y)}
  def get_instruction("jgz " <> rest) do
    [x, y] = String.split(rest, " ")
    case Integer.parse(x) do
      :error -> {:jgz, hd(String.to_charlist(x)), reg_or_num(y)}
      {num,_} -> {:jgz, num, reg_or_num(y)}
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

  def evaluate(_instruction_set, current_instruction, _registers, parent, name) when current_instruction < 0, do: send(parent, {name, :term})
  def evaluate(instruction_set, current_instruction, registers, parent, name) do
    if current_instruction > (Map.keys(instruction_set) |> Enum.count) - 1 do
      send(parent, {name, :term})
    else
      eval(Map.get(instruction_set, current_instruction), instruction_set, current_instruction, registers, parent, name)
    end
  end

  def eval({:snd, x}, instruction_set, current_instruction, registers, parent, name) do 
    send(parent, {name, get_val(registers, x)})
    evaluate(instruction_set, current_instruction + 1, registers, parent, name)
  end
  def eval({:rcv, x}, instruction_set, current_instruction, registers, parent, name) do
    print_b(name, {:rcv, x})
    receive do
      val -> evaluate(instruction_set, current_instruction + 1, Map.put(registers, x, val), parent, name)
    end
  end 
  def eval({:set, x, y}, instruction_set, current_instruction, registers, parent, name) do 
    evaluate(instruction_set, current_instruction + 1, Map.put(registers, x, get_val(registers, y)), parent, name)
  end
  def eval({:add, x, y}, instruction_set, current_instruction, registers, parent, name) do 
    evaluate(instruction_set, current_instruction + 1, Map.update!(registers, x, fn val -> val + get_val(registers, y) end), parent, name)
  end
  def eval({:mul, x, y}, instruction_set, current_instruction, registers, parent, name) do
    evaluate(instruction_set, current_instruction + 1, Map.update!(registers, x, fn val -> val * get_val(registers, y) end), parent, name)
  end 
  def eval({:mod, x, y}, instruction_set, current_instruction, registers, parent, name) do 
    evaluate(instruction_set, current_instruction + 1, Map.update!(registers, x, fn val -> rem(val, get_val(registers, y)) end), parent, name)
  end 
  def eval({:jgz, x, y}, instruction_set, current_instruction, registers, parent, name) do 
    if Map.get(registers, get_val(registers,x)) > 0 do
      evaluate(instruction_set, current_instruction + get_val(registers, y), registers, parent, name)
    else
      evaluate(instruction_set, current_instruction + 1, registers, parent, name)
    end
  end 

  def print_a(name, x) do
    if name == :a, do: IO.inspect x, else: :ok
  end

  def print_b(name, x) do
    if name == :b, do: IO.inspect x, else: :ok
  end

  def write_b(name, x) do
    if name == :b, do: File.write!("out", x, [:append]), else: :ok
  end
end
