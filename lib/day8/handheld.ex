defmodule Day8.Handheld do

  alias Day8.InstructionParser, as: IP
  alias Day8.Program

  def run_program() do
    read_program()
    |> IP.parse()
    |> Program.run()
  end

  defp read_program() do
    # "assets/day8_test.txt"
    "assets/day8_input.txt"
    |> Input.read_file()
  end

end
