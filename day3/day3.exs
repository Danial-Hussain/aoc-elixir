defmodule Part1 do
  def run() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(
      &(MapSet.intersection(
          MapSet.new(String.codepoints(String.slice(&1, 0..(div(String.length(&1), 2) - 1)))),
          MapSet.new(String.codepoints(String.slice(&1, div(String.length(&1), 2)..-1)))
        )
        |> Enum.at(0))
    )
    |> Enum.map(
      &if String.upcase(&1) == &1 do
        <<priority::utf8>> = &1
        priority - 65 + 27
      else
        <<priority::utf8>> = &1
        priority - 97 + 1
      end
    )
    |> Enum.sum()
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(
      &(MapSet.intersection(
          MapSet.new(String.codepoints(Enum.at(&1, 0))),
          MapSet.new(String.codepoints(Enum.at(&1, 1)))
        )
        |> MapSet.intersection(MapSet.new(String.codepoints(Enum.at(&1, 2))))
        |> Enum.at(0))
    )
    |> Enum.map(
      &if String.upcase(&1) == &1 do
        <<priority::utf8>> = &1
        priority - 65 + 27
      else
        <<priority::utf8>> = &1
        priority - 97 + 1
      end
    )
    |> Enum.sum()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
