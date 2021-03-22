defmodule Day3.Map do

  alias Day3.Map

  defstruct(
    map: [],
    len_x: 0,
    len_y: 0
  )

  def create(map) do
    map
    |> Enum.reverse()
    |> create([])
    |> to_struct()
  end

  def value_at(%Map{len_x: len_x} = map, x, y) when x >= len_x do
    value_at(map, rem(x, len_x), y)
  end

  def value_at(%Map{len_y: len_y}, _x, y) when y >= len_y do
    {:error, "index out of bounds"}
  end

  def value_at(%Map{map: map}, x, y) do
    value = map
    |> Enum.at(y)
    |> Enum.at(x)

    {:ok, value, x, y}
  end

  defp create([head | rem], map) do
    line =
      head
      |> String.codepoints()

    rem
    |> create([line | map])
  end

  defp create([], map), do: map

  defp to_struct([line1 | _] = map) do
    len_x = line1 |> Enum.count()
    len_y = map |> Enum.count()

    %Map{map: map, len_x: len_x, len_y: len_y}
  end

end
