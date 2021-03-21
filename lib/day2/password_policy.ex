defmodule Day2.PasswordPolicy do
  defstruct(
    char: '',
    min: 0,
    max: 0,
    password: ''
  )

  def count_valid_by_count() do
    valid_passwords(&is_valid_by_count/1)
  end

  def count_valid_by_position() do
    valid_passwords(&is_valid_by_position/1)
  end

  defp read_input do
    "assets/day2_input1.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  defp valid_passwords(validator) do
    read_input()
    |> Enum.map(&parse/1)
    |> Enum.filter(validator)
    |> Enum.count()
  end

  defp parse(password) do
    password
    |> String.split(" ")
    |> to_struct()
  end

  defp to_struct([mix_max, dchar, password]) do
    [min, max] = mix_max |> String.split("-")
    char = dchar |> String.codepoints() |> hd()

    %Day2.PasswordPolicy{
      char: char,
      min: parse_integer(min),
      max: parse_integer(max),
      password: password
    }
  end

  defp parse_integer(char) do
    char
    |> Integer.parse()
    |> elem(0)
  end

  defp is_valid_by_count(%{password: password, min: min, max: max, char: char}) do
    password
    |> String.codepoints()
    |> Enum.count(fn elem -> elem == char end)
    |> check_min_max(min, max)
  end

  defp is_valid_by_position(%{password: password, min: min, max: max, char: char}) do
    password
    |> String.codepoints()
    |> check_positions(min, max, char)
  end

  defp check_min_max(times, min, max) when times >= min and times <= max, do: true

  defp check_min_max(_times, _min, _max), do: false

  defp check_positions(password, p1, p2, char) do
    char_p1 = password |> Enum.at(p1 - 1)
    char_p2 = password |> Enum.at(p2 - 1)

    check_positions(char, char_p1, char_p2)
  end

  defp check_positions(_char, char1, char2) when char1 == char2, do: false

  defp check_positions(char, char1, char2) when char == char1 or char == char2, do: true

  defp check_positions(_char, _char1, _char2), do: false

end
