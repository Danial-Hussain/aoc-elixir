defmodule Part1 do
  def run() do
    content = File.read!("input.txt") |> String.graphemes()

    answer =
      content
      |> Enum.with_index(1)
      |> Enum.reject(fn {_, i} ->
        MapSet.new(Enum.slice(content, i..(i + 3)))
        |> MapSet.size() != 4
      end)
      |> List.first()
      |> elem(1)

    IO.inspect(answer + 4)
  end
end

defmodule Part2 do
  def run() do
    content = File.read!("input.txt") |> String.graphemes()

    answer =
      content
      |> Enum.with_index(1)
      |> Enum.reject(fn {_, i} ->
        MapSet.new(Enum.slice(content, i..(i + 13)))
        |> MapSet.size() != 14
      end)
      |> List.first()
      |> elem(1)

    IO.inspect(answer + 14)
  end
end

Part1.run()
Part2.run()
