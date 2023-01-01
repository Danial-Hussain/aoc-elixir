defmodule Part1 do
  def run() do
    File.read!("input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(
      &(String.split(&1, "\n")
        |> Enum.map(fn calories -> String.to_integer(calories) end)
        |> Enum.sum())
    )
    |> Enum.sort(:desc)
    |> Enum.at(0)
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    File.read!("input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(
      &(String.split(&1, "\n")
        |> Enum.map(fn calories -> String.to_integer(calories) end)
        |> Enum.sum())
    )
    |> Enum.sort(:desc)
    |> Enum.slice(0..2)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
