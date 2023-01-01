defmodule Shared do
  def parse() do
    content = File.read!("input.txt") |> String.split("\n", trim: true)
    stacks_end = Enum.find_index(content, &(String.at(&1, 1) == "1"))

    supply_stacks =
      content
      |> Enum.slice(0..(stacks_end - 1))
      |> Enum.map(&(String.codepoints(&1) |> Enum.slice(1..-1)))
      |> Enum.map(&Enum.chunk_every(&1, 1, 4, :discard))
      |> Enum.map(&Enum.map(&1, fn v -> v |> Enum.at(0) end))
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.reject(&1, fn v -> v == " " end))
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> {i + 1, row} end)
      |> Map.new()

    instructions =
      content
      |> Enum.slice((stacks_end + 1)..-1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(
        &%{
          :quantity => Enum.at(&1, 1) |> String.to_integer(),
          :from => Enum.at(&1, 3) |> String.to_integer(),
          :to => Enum.at(&1, 5) |> String.to_integer()
        }
      )

    {supply_stacks, instructions}
  end
end

defmodule Part1 do
  def run() do
    {supply_stacks, instructions} = Shared.parse()

    Enum.reduce(instructions, supply_stacks, fn instruction, supply_stacks ->
      to = Map.fetch!(instruction, :to)
      from = Map.fetch!(instruction, :from)
      quantity = Map.fetch!(instruction, :quantity)

      to_column = Map.fetch!(supply_stacks, to)
      from_column = Map.fetch!(supply_stacks, from)

      {move_values, keep_values} = Enum.split(from_column, quantity)
      new_to_column = Enum.reverse(move_values) ++ to_column

      %{supply_stacks | from => keep_values, to => new_to_column}
    end)
    |> Enum.to_list()
    |> Enum.map(&(elem(&1, 1) |> List.first()))
    |> Enum.join()
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    {supply_stacks, instructions} = Shared.parse()

    Enum.reduce(instructions, supply_stacks, fn instruction, supply_stacks ->
      to = Map.fetch!(instruction, :to)
      from = Map.fetch!(instruction, :from)
      quantity = Map.fetch!(instruction, :quantity)

      to_column = Map.fetch!(supply_stacks, to)
      from_column = Map.fetch!(supply_stacks, from)

      {move_values, keep_values} = Enum.split(from_column, quantity)
      new_to_column = move_values ++ to_column

      %{supply_stacks | from => keep_values, to => new_to_column}
    end)
    |> Enum.to_list()
    |> Enum.map(&(elem(&1, 1) |> List.first()))
    |> Enum.join()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
