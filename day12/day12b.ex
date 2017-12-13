defmodule Day12B do

  def solve(input) do
    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.map(&to_linkages/1)
    |> Enum.reduce(:digraph.new, fn linkages, digraph -> add_edges(linkages, digraph) end)
    |> :digraph_utils.strong_components
    |> Enum.count
  end

  def to_linkages(string) do
    [program, outs] = String.split(string, " <-> ")
    {program, String.split(outs, ", ")}
  end

  def add_edges({program, outs}, digraph) do
    Enum.each([program|outs], fn vertex -> :digraph.add_vertex(digraph, vertex) end)
    Enum.each(outs, fn out -> :digraph.add_edge(digraph, program, out); :digraph.add_edge(digraph, out, program) end)
    digraph
  end

  def add_vertices(digraph, vertices), do: Enum.each(vertices, fn vertex -> :digraph.add_vertex(digraph, vertex) end)
end