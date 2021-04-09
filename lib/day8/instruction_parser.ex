defmodule Day8.InstructionParser do
  alias Day8.Instruction

  def parse(instructions), do: parse(instructions, [])

  defp parse([], instructions), do: instructions |> Enum.reverse()

  defp parse([instruction | instructions], parsed_instructions) do
    parsed_instruction =
      ~r/(?<opcode>[a-z]{3}) (?<signal>[+-])(?<number>[0-9]*)/
      |> Regex.named_captures(instruction)
      |> Instruction.create()

    parse(instructions, [parsed_instruction | parsed_instructions])
  end
end
