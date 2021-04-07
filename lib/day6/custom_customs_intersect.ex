defmodule CustomCustomsIntersect do
  def count_answers() do
    read_input()
    |> build_groups([])
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defp build_groups([answers | []], groups), do: [answers | groups]

  defp build_groups([answers | [[] | remaining]], groups) do
    build_groups(remaining, [answers | groups])
  end

  defp build_groups([ans1 | [ans2 | remaining]], groups) do
    ans = ans1 |> merge(ans2)
    build_groups([ans | remaining], groups)
  end

  defp merge(ans1, ans2) do
    ans1
    |> Enum.filter(&(Enum.member?(ans2, &1)))
  end

  defp read_input do
    "assets/day6_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
  end
end
