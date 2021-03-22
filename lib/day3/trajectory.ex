defmodule Day3.Trajectory do

  alias Day3.{Map, Search}

  def multiply_trees do
    [{1,1}, {3,1}, {5,1}, {7,1}, {1,2}]
    |> Enum.map(&count_trees/1)
    |> Enum.reduce(&(&1*&2))
  end

  def count_trees(slope) do
    read_input()
    |> Map.create()
    |> Search.start(slope)
  end

  defp read_input do
    "assets/day3_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
