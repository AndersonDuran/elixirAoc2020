defmodule Aoc2020 do

  alias Day1.ReportRepair, as: RR
  alias Day2.PasswordPolicy

  def run_d1_t1 do
    RR.find_number_1()
  end

  def run_d1_t2 do
    RR.find_number_2()
  end

  def run_d2_t1 do
    PasswordPolicy.valid_passwords()
  end

end
