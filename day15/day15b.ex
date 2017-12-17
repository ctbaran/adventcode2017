defmodule Day15B do
  use Bitwise

  @factor_a 16807
  @factor_b 48271

  @multiple_a 4
  @multiple_b 8

  def solve(a, b) do
    first_a = generate(a, :a)
    first_b = generate(b, :b)

    Stream.iterate({first_a, first_b}, fn {prev_a,prev_b} -> {generate(prev_a, :a), generate(prev_b, :b)} end)
    |> Stream.take(5000000)
    |> Stream.filter(&match/1)
    |> Enum.count
  end

  def generate(num, :a) do
    new_num = rem(num * @factor_a, 2147483647)
    if rem(new_num, @multiple_a) == 0 do
      new_num
    else
      generate(new_num, :a)
    end
  end

  def generate(num, :b) do
    new_num = rem(num * @factor_b, 2147483647)
    if rem(new_num, @multiple_b) == 0 do
      new_num
    else
      generate(new_num, :b)
    end
  end

  def match({a, b}) do
    encoded_a = :binary.encode_unsigned(a)
    encoded_b = :binary.encode_unsigned(b)

    case {byte_size(encoded_a) > 1, byte_size(encoded_b) > 1} do
      {true, true} -> :binary.part(encoded_a, {byte_size(encoded_a), -2}) == :binary.part(encoded_b, {byte_size(encoded_b), -2})
      {false, true} -> <<0>> <> encoded_a == :binary.part(encoded_b, {byte_size(encoded_b), -2})
      {true, false} -> :binary.part(encoded_a, {byte_size(encoded_a), -2}) == <<0>> <> encoded_b
      {false, false} -> <<0>> <> encoded_a == <<0>> <> encoded_b
    end
  end
end