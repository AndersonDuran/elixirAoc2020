defmodule Passport do
  def validate do
    read_input()
    |> scan_passports()
    |> validate_passports()
    |> Enum.count()
  end

  defp validate_passports(passports) do
    passports
    |> Enum.filter(&has_required_fields/1)
    |> Enum.filter(&validate_fields/1)
  end

  defp has_required_fields(passport) do
    ~w[byr iyr eyr hgt hcl ecl pid]
    |> Enum.all?(&has_field(passport, &1))
  end

  defp has_field(passport, key) do
    passport
    |> Map.has_key?(key)
  end

  #of course the best solution here would be creating a gereric validator function
  #which takes a passport and a validator function for each field

  defp validate_fields(passport) do
    validate_byr({:ok, passport})
    |> validate_iyr()
    |> validate_eyr()
    |> validate_hgt()
    |> validate_hcl()
    |> validate_ecl()
    |> validate_pid()
    |> as_boolean_response()
  end

  defp as_boolean_response({:ok, _}), do: true

  defp as_boolean_response(_), do: false

  defp validate_byr({:ok, passport}) do
    {byr, _} =
      passport
      |> Map.get("byr")
      |> Integer.parse()

    validate_field(byr >= 1920 and byr <= 2002, passport)
  end

  defp validate_iyr({:ok, passport}) do
    {iyr, _} =
      passport
      |> Map.get("iyr")
      |> Integer.parse()

    validate_field(iyr >= 2010 and iyr <= 2020, passport)
  end

  defp validate_iyr({:invalid}), do: {:invalid}

  defp validate_eyr({:ok, passport}) do
    {eyr, _} =
      passport
      |> Map.get("eyr")
      |> Integer.parse()

    validate_field(eyr >= 2020 and eyr <= 2030, passport)
  end

  defp validate_eyr({:invalid}), do: {:invalid}

  defp validate_hgt({:ok, passport}) do
    regex = ~r/^(?<value>[\d]{2,3})(?<unit>in|cm)+/

    hgt = passport |> Map.get("hgt")

    case Regex.named_captures(regex, hgt) do
      nil ->
        validate_field(false, passport)

      captured ->
        unit = captured |> Map.get("unit")
        {value, _} = captured |> Map.get("value") |> Integer.parse()

        cm_cond = unit == "cm" and value >= 150 and value <= 193
        in_cond = unit == "in" and value >= 59 and value <= 76

        validate_field(cm_cond or in_cond, passport)
    end
  end

  defp validate_hgt({:invalid}), do: {:invalid}

  defp validate_hcl({:ok, passport}) do
    regex = ~r/^#([0-9|a-f]{6})/
    hcl = passport |> Map.get("hcl")

    validate_field(String.match?(hcl, regex), passport)
  end

  defp validate_hcl({:invalid}), do: {:invalid}

  defp validate_ecl({:ok, passport}) do
    regex = ~r/^(amb|blu|brn|gry|grn|hzl|oth)\b/
    ecl = passport |> Map.get("ecl")

    validate_field(String.match?(ecl, regex), passport)
  end

  defp validate_ecl({:invalid}), do: {:invalid}

  defp validate_pid({:ok, passport}) do
    regex = ~r/^([0-9]{9})$/
    pid = passport |> Map.get("pid")

    validate_field(String.match?(pid, regex), passport)
  end

  defp validate_pid({:invalid}), do: {:invalid}

  defp validate_field(true, passport), do: {:ok, passport}

  defp validate_field(_, _passport), do: {:invalid}

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
