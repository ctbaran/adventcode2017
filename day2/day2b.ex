defmodule Day2B do
  def solve(file) do
    File.stream!(file)
    |> Stream.map(&to_nums/1)
    |> Stream.map(&to_checksum/1)
    |> Enum.sum
  end

  def to_checksum([first|rest]) do
    to_checksum_helper(rest, [first])
  end

  def to_checksum_helper([first|rest], numbers) do
    case evenly_divides(first, numbers) do
      {true, n} -> n
      false -> to_checksum_helper(rest, [first|numbers])
    end
  end

  def evenly_divides(_, []) do
    false
  end

  def evenly_divides(n, [first|rest]) do
    cond do
      rem(n, first) == 0 -> {true, div(n, first)}
      rem(first, n) == 0 -> {true, div(first, n)}
      true -> evenly_divides(n, rest)  
    end
  end

  def to_nums(line) do
    String.split(line)
    |> Enum.map(&get_int/1)
  end

  def get_int(n) do
    {int, _} = Integer.parse(n)
    int
  end
end