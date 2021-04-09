defmodule Day9.XmasEncoding do
  def validate_test() do
    "assets/day9_test.txt"
    |> read_data()
    |> validate(5)
  end

  def validate_xmas() do
    "assets/day9_input.txt"
    |> read_data()
    |> validate(25)
  end

  def find_weakness_test(number) do
    numbers =
      "assets/day9_test.txt"
      |> read_data()
      |> as_numbers()

    sizes = for i <- 3..5, do: i

    find_weakness({false, numbers}, sizes, number)
  end

  def find_weakness_xmas(number) do
    numbers =
      "assets/day9_input.txt"
      |> read_data()
      |> as_numbers()

    sizes = for i <- 3..50, do: i

    find_weakness({false, numbers}, sizes, number)
  end

  defp find_weakness({true, numbers}, _sizes, _number) do
    IO.puts("Weakness found!")

    {n1, n2} =
      numbers
      |> Enum.min_max()

    n1 + n2
  end

  defp find_weakness(_, [], _number) do
    IO.puts("No weaknesses found!")
    exit(0)
  end

  defp find_weakness({false, numbers}, [size | sizes], number) do
    numbers
    |> Enum.chunk_every(size, 1, :discard)
    |> Enum.map(&{&1, Enum.sum(&1)})
    |> Enum.filter(fn {_result, value} -> value == number end)
    |> Enum.map(fn {result, _value} -> result end)
    |> to_result(numbers)
    |> find_weakness(sizes, number)
  end

  defp to_result([], numbers), do: {false, numbers}

  defp to_result([result], _numbers), do: {true, result}

  defp as_numbers({:valid, data}) do
    data
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end

  defp read_data(file) do
    data =
      file
      |> Input.read_file()

    {:valid, data}
  end

  defp validate({:ok}, _preable_size) do
    IO.puts("Data is valid!")
    exit(0)
  end

  defp validate({:invalid, number}, _preable_size) do
    IO.puts("Invalid data, #{number} is illegal!")
    exit(0)
  end

  defp validate({:valid, data}, preable_size) do
    data_length = Enum.count(data)

    validate_next(data, preable_size, data_length)
    |> validate(preable_size)
  end

  defp validate_next(_data, preamble_size, data_length)
       when data_length < preamble_size + 1,
       do: {:ok}

  defp validate_next(data, preamble_size, data_length) do
    number =
      data
      |> Enum.at(preamble_size)
      |> Integer.parse()
      |> elem(0)

    validation =
      data
      |> Enum.slice(0, preamble_size)
      |> is_valid(number)

    remaining_data =
      data
      |> Enum.slice(1, data_length)

    validation_result(validation, number, remaining_data)
  end

  defp is_valid(preamble, number) do
    IO.puts("Checking #{number}...")

    preamble
    |> combine_numbers()
    |> Enum.map(&add_numbers/1)
    |> Enum.count(&(&1 == number))
    |> is_valid()
  end

  defp is_valid(n) when n == 0, do: :invalid

  defp is_valid(_n), do: :valid

  defp add_numbers([n1, n2]) do
    add_numbers(n1, n2)
  end

  defp add_numbers(n1, n2) do
    int1 = n1 |> Integer.parse() |> elem(0)
    int2 = n2 |> Integer.parse() |> elem(0)
    int1 + int2
  end

  defp combine_numbers(preamble) do
    for i <- preamble,
        j <- preamble,
        i != j,
        do: [i, j]
  end

  defp validation_result(:valid, _number, remaining_data) do
    {:valid, remaining_data}
  end

  defp validation_result(:invalid, number, _remaining_data) do
    {:invalid, number}
  end
end
