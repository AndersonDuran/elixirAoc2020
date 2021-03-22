defmodule Day3.Search do
  alias Day3.{Search, Map}

  defstruct(
    map: %Map{},
    y: 0,
    x: 0,
    hits: 0
  )

  def start(map, slope) do
    search(%Search{map: map}, "#", slope)
    |> to_result()
  end

  def search(%{map: map, x: x, y: y} = state, char, slope) do
    search(state, Map.value_at(map, x, y), char, slope)
  end

  def search(%Search{hits: cur_hits, y: cury} = state, {:ok, value, x, _y}, char, {sx, sy} = slope) when char == value do
    %Search{state | hits: cur_hits + 1, x: x + sx, y: cury + sy}
    |> search(char, slope)
  end

  def search(%Search{y: cury} = state, {:ok, _value, x, _y}, char, {sx, sy} = slope) do
    %Search{state | x: x + sx, y: cury + sy}
    |> search(char, slope)
  end

  def search(state, {:error, _value}, _char, _slope) do
    state
  end

  defp to_result(%Search{hits: hits}), do: hits
end
