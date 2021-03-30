defmodule Passport do
  def validate do
    read_input()
    |> scan_passports()
    |> Enum.filter(&has_required_fields/1)
    |> Enum.count()
  end

  defp has_required_fields(passport) do
    ~w[byr iyr eyr hgt hcl ecl pid]
    |> Enum.all?(&(has_field(passport, &1)))
  end

  defp has_field(passport, key) do
    passport
    |> Map.has_key?(key)
  end

  defp scan_passports(data, passport \\ %{}, passports \\ [])

  defp scan_passports(["" | remaining_data], passport, passports) do
    scan_passports(remaining_data, %{}, [passport | passports])
  end

  defp scan_passports([data | remaining_data], passport, passports) do
    updated_passport =
      data
      |> String.split(" ")
      |> scan_fields(passport)

    scan_passports(remaining_data, updated_passport, passports)
  end

  defp scan_passports([], passport, passports), do: [passport | passports]

  defp scan_fields([], %{} = passport), do: passport

  defp scan_fields([field | remaining_fields], %{} = passport) do
    [key | [value]] =
      field
      |> String.split(":")

    updated_passport = Map.put(passport, key, value)
    scan_fields(remaining_fields, updated_passport)
  end

  defp read_input do
    "assets/day4_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
