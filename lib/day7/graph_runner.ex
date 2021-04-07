defmodule Day7.GraphRunner do
  alias Day7.BagNode

  def find_outermost_bags(bag_rules, color) do
    bag_rules
    |> IO.inspect()
    |> find_bags_that_contain(color)
    |> find_bags(bag_rules, MapSet.new())
    |> MapSet.to_list()
  end

  defp find_bags_that_contain(bag_rules, color) do
    bag_rules
    |> Enum.filter(fn %BagNode{contains: contains} -> contains == color end)
  end

  defp find_bags([], _bag_rules, bags), do: bags

  defp find_bags([%BagNode{name: name} | container_bags], bag_rules, bags) do
    found_bags =
      bag_rules
      |> find_bags_that_contain(name)
      |> find_bags(bag_rules, bags)
      |> MapSet.union(bags)
      |> MapSet.put(name)

    container_bags
    |> find_bags(bag_rules, found_bags)
  end
end
