defmodule Day2.PasswordPolicy do



  defp read_input do
    "assets/day2_test1.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  def valid_passwords() do
    read_input()
    |> Enum.map(&parse/1)
  end

  defp parse(password) do
    password
    |> String.split(" ")
    |> parse_min_max()
  end

  #
  # 11-12
  # x:
  # xxxxxxlxxxxpxxx
  defp parse_min_max([head | rem]) do
    head
    |> String.split("-")
    |> parse_char(rem)
  end

  defp parse_char([min, max], [char | rem]) do
    res = char
    |> String.codepoints()
    |> hd()

    {min, max, res, rem |> hd}
  end


end
