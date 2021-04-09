defmodule Day8.ChangeInstruction do
  alias Day8.{InstructionParser, Program, Instruction}

  def search() do
    read_program()
    |> InstructionParser.parse()
    |> check_program()
    |> Program.run()
  end

  defp read_program() do
    # "assets/day8_test.txt"
    "assets/day8_input.txt"
    |> Input.read_file()
  end

  defp check_program(program) do
    program
    |> Enum.count(fn %Instruction{opcode: opcode} -> opcode == "nop" end)
    |> IO.inspect()

    program
  end
end
