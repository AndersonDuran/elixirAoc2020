defmodule BoardingPass do
  # FBFBBFF RLR

  def decode(code) do
    {row_code, col_code} =
      code
      |> split_code()

    row = row_code |> decode_row()
    col = col_code |> decode_col()

    row * 8 + col
  end

  def highest_seat_id() do
    read_input()
    |> calc_highest_seat_id(0)
  end

  def missing_seats() do
    read_input()
    |> Enum.map(&decode/1)
    |> missing_seats(32..848)
  end

  defp missing_seats(seats, all_seats) do
    IO.inspect(seats)
    all_seats
    |> IO.inspect()
    |> Enum.filter(fn seat -> !Enum.member?(seats, seat) end)
  end


  defp calc_highest_seat_id([], highest), do: highest

  defp calc_highest_seat_id([code | codes], highest) do
    max_seat_id =
      code
      |> decode()
      |> max_seat_id(highest)

    calc_highest_seat_id(codes, max_seat_id)
  end

  defp max_seat_id(seat_a, seat_b) when seat_a > seat_b, do: seat_a

  defp max_seat_id(_seat_a, seat_b), do: seat_b

  defp read_input do
    "assets/day5_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  defp split_code(code) do
    code
    |> String.split_at(7)
  end

  defp decode_row(row_code) do
    row_code
    |> String.codepoints()
    |> decode_row(0, 127)
    |> trunc()
  end

  defp decode_row(["F" | []], inf, _sup), do: inf

  defp decode_row(["B" | []], _inf, sup), do: sup

  defp decode_row(["F" | remaining_codes], inf, sup) do
    block_size = (sup - inf + 1) / 2
    decode_row(remaining_codes, inf, inf + block_size - 1)
  end

  defp decode_row(["B" | remaining_codes], inf, sup) do
    block_size = (sup - inf + 1) / 2
    decode_row(remaining_codes, inf + block_size, sup)
  end

  defp decode_col(col_code) do
    col_code
    |> String.codepoints()
    |> decode_col(0, 7)
    |> trunc()
  end

  defp decode_col(["L" | []], inf, _sup), do: inf

  defp decode_col(["R" | []], _inf, sup), do: sup

  defp decode_col(["L" | remaining_codes], inf, sup) do
    block_size = (sup - inf + 1) / 2
    decode_col(remaining_codes, inf, inf + block_size - 1)
  end

  defp decode_col(["R" | remaining_codes], inf, sup) do
    block_size = (sup - inf + 1) / 2
    decode_col(remaining_codes, inf + block_size, sup)
  end
end
