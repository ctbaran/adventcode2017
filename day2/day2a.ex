defmodule Day2A do
  def solve(file) do
    File.stream!(file)
    |> Stream.map(&to_nums/1)
    |> Stream.map(&to_checksum/1)
    |> Enum.sum
  end

  def to_checksum([first|rest]) do
    to_checksum_helper(rest, first, first)
  end

  def to_checksum_helper([], min, max) do
    max - min
  end

  def to_checksum_helper([x|rest], min, max) do
    cond do
        x < min -> to_checksum_helper(rest, x, max)
        x > max -> to_checksum_helper(rest, min, x)
        true -> to_checksum_helper(rest, min, max)
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