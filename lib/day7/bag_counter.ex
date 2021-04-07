defmodule Day7.BagCounter do
  alias Day7.BagNode

  def count_bags_inside(bag_rules, bag_color \\ "shiny gold") do
    (bag_rules
     |> get_bag_by_color(bag_color)
     |> count_bags(bag_rules, 1)) - 1
  end

  defp get_bag_by_color(bag_rules, color) do
    bag_rules
    |> Enum.find(nil, fn %BagNode{name: name} -> name == color end)
  end

  defp count_bags(nil, _bag_rules, parent_bag_count), do: parent_bag_count

  defp count_bags(%BagNode{} = bag, bag_rules, parent_bag_count) do
    bag.name
    |> get_bag_contents(bag_rules)
    |> count_child_bags(bag_rules, parent_bag_count, 0)
  end

  defp count_child_bags([], _bag_rules, parent_bag_count, count), do: count + parent_bag_count

  defp count_child_bags([%BagNode{} = parent_bag | other_bags], bag_rules, parent_bag_count, count) do
    bag_count =
      bag_rules
      |> get_bag_by_color(parent_bag.contains)
      |> count_bags(bag_rules, parent_bag.count)

    branch = bag_count * parent_bag_count

    count_child_bags(other_bags, bag_rules, parent_bag_count, count + branch)
  end

  defp get_bag_contents(bag_color, bag_rules) do
    bag_rules
    |> Enum.filter(fn %BagNode{name: name} -> name == bag_color end)
  end
end
