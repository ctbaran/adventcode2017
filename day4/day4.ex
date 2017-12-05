defmodule Day4 do
  def solve(file) do
    File.stream!(file)
    |> Stream.filter(&is_valid/1)
    |> Enum.count
  end

  def is_valid(phrase) do
    words = String.split(phrase)
    Enum.count(words) == Enum.count(MapSet.new(words))
  end
end