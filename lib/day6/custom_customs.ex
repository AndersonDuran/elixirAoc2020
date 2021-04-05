defmodule CustomCustoms do

  def count_answers() do
    read_input()
    |> group_answers([])
    |> remove_duplicates()
    |> Enum.map(&MapSet.new/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defp remove_duplicates(answers) do
    answers
    |> Enum.map(&String.codepoints/1)
  end

  defp group_answers([], groups), do: groups

  defp group_answers([answers | []], groups) do
    group_answers([], [answers | groups])
  end

  defp group_answers([answers | ["" | remaining]], groups) do
    group_answers(remaining, [answers | groups])
  end

  defp group_answers([answers_p1 | [answers_p2 | remaining]], groups) do
    group_answers([answers_p1 <> answers_p2 | remaining], groups)
  end

  defp read_input do
    "assets/day6_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
