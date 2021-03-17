defmodule Day1.ReportRepair do

  defp read_input do
    "assets/day1_input1.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&(elem(Integer.parse(&1), 0)))
  end

  def find_number_1() do
    read_input()
    |> find_two_numbers(2020)
    |> multiply()
  end

  defp find_two_numbers([num1 | remaining], sum) do
    remaining
    |> Enum.filter(&(&1 == sum - num1))
    |> has_match(num1, remaining, sum)
  end

  defp has_match([num2 | _], num1, _, _), do: {num1, num2}

  defp has_match([], _, [], _), do: :not_found

  defp has_match([], _, remaining, sum), do: find_two_numbers(remaining, sum)

  defp multiply({num1, num2, num3}), do: num1*num2*num3

  defp multiply({num1, num2}), do: num1*num2


  def find_number_2() do
    read_input()
    |> find_three_numbers()
    |> multiply()
  end

  defp find_three_numbers([num1 | remaining]) do
    remaining
    |> find_two_numbers(2020 - num1)
    |> has_match_three(remaining, num1)
  end

  defp has_match_three({num2, num3}, _, num1), do: {num1, num2, num3}

  defp has_match_three(:not_found, remaining, _), do: find_three_numbers(remaining)

end
