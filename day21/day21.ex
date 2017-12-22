defmodule Day21 do

  def solve(input, iterations) do
    enhancements = File.stream!(input)
                   |> Stream.map(&String.strip/1)
                   |> Stream.map(&to_enhancement/1)
                   |> Enum.reduce(Map.new, fn {pattern, enhancement}, acc -> Map.put(acc, pattern, enhancement) end)

    iterate(init(), enhancements, 3, iterations)
    |> print_image
    |> Map.values
    |> Enum.filter(fn x -> x == :on end)
    |> Enum.count
  end

  def init() do
    gen_coords(0..2, 0..2, :flatten)
    |> Enum.reduce(Map.new, fn coord, acc -> Map.put(acc, coord, :off) end)
    |> Map.put({1, 0}, :on)
    |> Map.put({2, 1}, :on)
    |> Map.put({0, 2}, :on)
    |> Map.put({1, 2}, :on)
    |> Map.put({2, 2}, :on)
  end

  def gen_coords(x_range, y_range, :nest), do: Enum.map(x_range, fn val1 -> Enum.map(y_range, fn val2 -> {val1, val2} end) end)
  def gen_coords(x_range, y_range, :flatten), do: Enum.flat_map(x_range, fn val1 -> Enum.map(y_range, fn val2 -> {val1, val2} end) end)

  def to_enhancement(string) do
    [pattern, enhancement] = String.split(string, " => ")
                             |> Enum.map(&(String.split(&1, "/")))
                             |> Enum.map(fn pattern -> to_pattern(pattern) end)

    {pattern, enhancement}
  end 

  def to_pattern(string) do
    Enum.map(string, &String.to_charlist/1)
    |> Enum.map(fn x -> Enum.map(x, fn char -> if char == ?#, do: :on, else: :off end) end)
  end

  def iterate(image, _enhancements, x, 0), do: image
  def iterate(image, enhancements, x, iterations) do
    if rem(x, 2) == 0 do
      subdivide(image, enhancements, x, 2)
      |> Enum.reduce(Map.new, fn {key, val}, acc -> Map.put(acc, key, val) end)
      |> iterate(enhancements, 3*div(x,2), iterations-1)
    else 
      subdivide(image, enhancements, x, 3)
      |> Enum.reduce(Map.new, fn {key, val}, acc -> Map.put(acc, key, val) end)
      |> iterate(enhancements, 4*div(x,3), iterations-1)
    end
  end

  
  def subdivide(image, enhancements, width, mult) do
    Stream.iterate(0, &(&1 + mult)) |> Enum.take(div(width, mult))
    |> Enum.flat_map(fn x -> Enum.map(Stream.iterate(0, &(&1 + mult)) |> Enum.take(div(width, mult)), fn y -> {x,y} end) end)
    |> Enum.flat_map(fn {x, y} -> enhance_subdivision(image, enhancements, mult, x, y) end)
  end

  def enhance_subdivision(image, enhancements, mult, x_offset, y_offset) do
    gen_coords(x_offset..x_offset+(mult-1), y_offset..y_offset+(mult-1), :nest)
    |> Enum.map(fn coord_list -> Enum.map(coord_list, fn coords -> Map.get(image, coords) end) end)
    |> enhance(enhancements, x_offset, y_offset, mult, :none)
  end

  def enhance(rows, enhancements, x_offset, y_offset, mult, :none) do
    case Map.get(enhancements, rows) do
      nil -> enhance(rows, enhancements, x_offset, y_offset, mult, :flip)  
      enhanced -> enhanced |> enhance_coords(x_offset + div(x_offset, mult), y_offset + div(y_offset, mult), mult)
    end
  end
  def enhance(rows, enhancements, x_offset, y_offset, mult, :flip) do
    case Map.get(enhancements, flip(rows)) do
      nil -> enhance(rows, enhancements, x_offset, y_offset, mult, :rotate)
      enhanced -> enhanced |> enhance_coords(x_offset + div(x_offset, mult), y_offset + div(y_offset, mult), mult)
    end
  end
  def enhance(rows, enhancements, x_offset, y_offset, mult, :rotate), do: enhance(rotate(rows), enhancements, x_offset, y_offset, mult, :none)

  def enhance_coords(rows, x_offset, y_offset, mult) do
    Enum.zip(gen_coords(x_offset..x_offset+mult, y_offset..y_offset+mult, :flatten), List.flatten(rows))
  end


  def flip(rows), do: Enum.map(rows, fn x -> Enum.reverse(x) end)

  def rotate([[x1,y1],[x2,y2]]), do: [[x2,x1],[y2,y1]]
  def rotate([[x1,y1,z1],[x2,y2,z2],[x3,y3,z3]]), do: [[x3,x2,x1],[y3,y2,y1],[z3,z2,z1]]

  def print_image(image) do
    Map.to_list(image)
    |> Enum.group_by(fn {{_x, y}, _val} -> y end)
    |> Map.to_list
    |> List.keysort(0)
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.map(fn list -> Enum.sort(list, fn {{x1, _y1}, _val1}, {{x2, _y2}, _val2}-> x2 >= x1 end) end)
    |> Enum.map(fn list -> Enum.reduce(list, "", fn {_, val}, acc -> acc <> to_char(val) end) end)
    |> Enum.join("\n")
    |> IO.puts

    image
  end

  def to_char(:on), do: "#"
  def to_char(:off), do: "."
end