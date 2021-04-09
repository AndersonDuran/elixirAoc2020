defmodule Day8.Program do
  alias Day8.Instruction

  def run(program), do: program |> create_context() |> start()

  defp create_context(program) do
    Map.new([
      {:program, program},
      {:ip, 0},
      {:already_ran, []},
      {:acc, 0}
    ])
  end

  defp start(%{program: [first_instruction | _]} = context) do
    context
    |> run_instruction(first_instruction)
  end

  defp run_program(%{ip: ip, program: program} = context) do
    instruction =
      program
      |> Enum.at(ip)
      |> IO.inspect()

    context
    |> loop_checker()
    |> run_instruction(instruction)
  end

  defp loop_checker(%{ip: ip, already_ran: already_ran} = context) do
    IO.puts("Running instruction #{ip + 1}")

    has_executed =
      already_ran
      |> Enum.member?(ip)

    context
    |> continue_or_halt(has_executed)
  end

  defp continue_or_halt(%{ip: ip, already_ran: already_ran} = context, false) do
    context
    |> Map.put(:already_ran, [ip | already_ran])
  end

  defp continue_or_halt(context, true) do
    context |> IO.inspect()
    exit(1)
  end

  defp increment_pointer(%{ip: ip} = context, count, "+") do
    context
    |> Map.put(:ip, ip + count)
  end

  defp increment_pointer(%{ip: ip} = context, count, "-") do
    context
    |> Map.put(:ip, ip - count)
  end

  defp update_data(context, key, acc) do
    context
    |> Map.put(key, acc)
  end

  defp run_instruction(context, %Instruction{opcode: "nop"}) do
    context
    |> increment_pointer(1, "+")
    |> run_program()
  end

  defp run_instruction(context, %Instruction{opcode: "acc"} = instr) do
    context
    |> run_operation(instr)
    |> increment_pointer(1, "+")
    |> run_program()
  end

  defp run_instruction(context, %Instruction{opcode: "jmp"} = instr) do
    context
    |> increment_pointer(instr.number, instr.signal)
    |> run_program()
  end

  defp run_instruction(context, nil) do
    IO.puts("Exited normally!")
    context
  end

  defp run_operation(%{acc: acc} = context, %Instruction{number: count, signal: "+"}) do
    context
    |> update_data(:acc, acc + count)
  end

  defp run_operation(%{acc: acc} = context, %Instruction{number: count, signal: "-"}) do
    context
    |> update_data(:acc, acc - count)
  end
end
