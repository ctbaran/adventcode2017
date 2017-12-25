defmodule Day25 do

  def solve(iterations) do
    do_state(:a, {[], [0]}, iterations)
    |> diagnostic_checksum
  end

  def do_state(_state, zipper, 0), do: zipper
  def do_state(state, zipper, iterations) do
    case state do
      :a -> do_state_a(zipper, iterations)
      :b -> do_state_b(zipper, iterations)
      :c -> do_state_c(zipper, iterations)
      :d -> do_state_d(zipper, iterations)
      :e -> do_state_e(zipper, iterations)
      :f -> do_state_f(zipper, iterations)
    end
  end

  def do_state_a({prev,[0|next]}, iterations), do: do_state(:b, move_right({prev, [1|next]}), iterations-1)
  def do_state_a({prev,[1|next]}, iterations), do: do_state(:b, move_left({prev, [0|next]}), iterations-1)

  def do_state_b({prev,[0|next]}, iterations), do: do_state(:c, move_right({prev, [0|next]}), iterations-1)
  def do_state_b({prev,[1|next]}, iterations), do: do_state(:b, move_left({prev, [1|next]}), iterations-1)

  def do_state_c({prev,[0|next]}, iterations), do: do_state(:d, move_right({prev, [1|next]}), iterations-1)
  def do_state_c({prev,[1|next]}, iterations), do: do_state(:a, move_left({prev, [0|next]}), iterations-1)

  def do_state_d({prev,[0|next]}, iterations), do: do_state(:e, move_left({prev, [1|next]}), iterations-1)
  def do_state_d({prev,[1|next]}, iterations), do: do_state(:f, move_left({prev, [1|next]}), iterations-1)

  def do_state_e({prev,[0|next]}, iterations), do: do_state(:a, move_left({prev, [1|next]}), iterations-1)
  def do_state_e({prev,[1|next]}, iterations), do: do_state(:d, move_left({prev, [0|next]}), iterations-1)  

  def do_state_f({prev,[0|next]}, iterations), do: do_state(:a, move_right({prev, [1|next]}), iterations-1)
  def do_state_f({prev,[1|next]}, iterations), do: do_state(:e, move_left({prev, [1|next]}), iterations-1)  

  def move_left({[prev|prevs],[current|next]}), do: {prevs, [prev,current|next]}
  def move_left({[], [current|next]}), do: {[], [0, current|next]}

  def move_right({prev, [current]}), do: {[current|prev], [0]}
  def move_right({prev, [current|next]}), do: {[current|prev], next}
  def move_right({prev, []}), do: {prev, [0]}

  def diagnostic_checksum({list1, list2}) do
    Enum.sum(list1) + Enum.sum(list2)
  end
end