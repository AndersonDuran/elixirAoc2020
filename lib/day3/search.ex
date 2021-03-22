defmodule Day3.Search do
  alias Day3.{Search, Map}

  defstruct(
    map: %Map{},
    y: 0,
    x: 0,
    hits: 0
  )

  def start(map) do
    search(%Search{map: map}, "#")
    |> to_result()
  end

  def search(%{map: map, x: x, y: y} = state, char) do
    search(state, Map.value_at(map, x, y), char)
  end

  def search(%Search{hits: cur_hits, y: cury} = state, {:ok, value, x, _y}, char) when char == value do
    %Search{state | hits: cur_hits + 1, x: x + 3, y: cury + 1}
    |> search(char)
  end

  def search(%Search{y: cury} = state, {:ok, _value, x, _y}, char) do
    %Search{state | x: x + 3, y: cury + 1}
    |> search(char)
  end

  def search(state, {:error, _value}, _char) do
    state
  end

  defp to_result(%Search{hits: hits}), do: hits
end
