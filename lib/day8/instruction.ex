defmodule Day8.Instruction do
  defstruct opcode: "", number: 1, signal: ""

  def create(map) do
    number =
      map
      |> Map.get("number")
      |> Integer.parse()
      |> elem(0)

    %Day8.Instruction{
      number: number,
      opcode: Map.get(map, "opcode"),
      signal: Map.get(map, "signal")
    }
  end

  def change_opcode(instruction, new_opcode) do
    %Day8.Instruction{instruction | opcode: new_opcode}
  end
end
