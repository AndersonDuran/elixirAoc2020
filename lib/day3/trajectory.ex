defmodule Day3.Trajectory do

  alias Day3.{Map, Search}

  def count_trees() do
    read_input()
    |> Map.create()
    |> Search.start()
  end

  defp read_input do
    "assets/day3_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
