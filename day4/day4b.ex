defmodule Day4B do
  def solve(file) do
    File.stream!(file)
    |> Stream.filter(&is_valid/1)
    |> Enum.count
  end

  def is_valid(phrase) do
    words = Enum.map(String.split(phrase), &String.to_charlist/1)
            |> Enum.map(&Enum.sort(&1))
            |> Enum.map(&to_string/1)
    IO.inspect words
    Enum.count(words) == Enum.count(MapSet.new(words))
  end
end