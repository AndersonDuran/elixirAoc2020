defmodule Input do

  def read_file(file_name) do
    file_name
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
