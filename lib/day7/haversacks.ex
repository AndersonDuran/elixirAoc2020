defmodule Day7.Haversacks do
  alias Day7.{BagNode, GraphRunner, BagCounter}

  def outermost_bags_for(contained_color \\ "shiny gold") do
    # "assets/day7_input.txt"
    "assets/day7_test.txt"
    |> build_graph()
    |> GraphRunner.find_outermost_bags(contained_color)
    |> Enum.count()
  end

  def contained_bags_for(contained_color \\ "shiny gold") do
    "assets/day7_input.txt"
    # "assets/day7_test.txt"
    |> build_graph()
    |> BagCounter.count_bags_inside(contained_color)
  end

  defp build_graph(rules_spec) do
    rules_spec
    |> Input.read_file()
    |> sanitize_input()
    |> to_bag_rules([])
    |> Enum.flat_map(&(&1))
  end

  defp sanitize_input(input) do
    input
    |> Enum.map(&String.replace(&1, ~r/bags|contain|\.|,/, ""))
    |> Enum.map(&String.replace(&1, ~r/bag/, ""))
    |> Enum.map(&String.split/1)
  end

  defp to_bag_rules([], bag_rules), do: bag_rules

  defp to_bag_rules([input_rule | input_rules], bag_rules) do
    bag_rule = input_rule |> parse_rule()

    to_bag_rules(input_rules, [bag_rule | bag_rules])
  end

  defp parse_rule([modifier | [color | contained_bags]]) do
    node_name(modifier, color)
    |> parse_contained_bags(contained_bags, [])
  end

  defp parse_contained_bags(_bag_color, [], parsed), do: parsed

  defp parse_contained_bags(_bag_color, ["no" | ["other" | []]], _parsed), do: []

  defp parse_contained_bags(bag_color, [count | [modifier | [color | contained_bags]]], parsed) do
    contained_bag = node_name(modifier, color)
    count_num = count |> Integer.parse() |> elem(0)

    parsed_bags = [%BagNode{name: bag_color, contains: contained_bag , count: count_num} | parsed]
    parse_contained_bags(bag_color, contained_bags, parsed_bags)
  end

  defp node_name(modifier, color), do: modifier <> " " <> color
end
