defmodule Part1 do
  def run() do
    trees =
      File.read!("input.txt")
      |> String.split("\n")
      |> Enum.map(&String.graphemes(&1))

    rows = length(trees)
    cols = length(List.first(trees))

    Enum.map(0..(rows - 1), fn row ->
      Enum.map(0..(cols - 1), fn col ->
        if row == 0 || row == rows - 1 || col == 0 || col == cols - 1 do
          1
        else
          value = trees |> Enum.at(row) |> Enum.at(col) |> String.to_integer()

          left =
            Enum.map(0..(col - 1), fn col ->
              tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()

              if tmp >= value do
                1
              else
                0
              end
            end)
            |> Enum.sum() == 0

          right =
            Enum.map((col + 1)..cols-1, fn col ->
              tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()

              if tmp >= value do
                1
              else
                0
              end
            end)
            |> Enum.sum() == 0

          up =
            Enum.map((row - 1)..0, fn row ->
              tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()

              if tmp >= value do
                1
              else
                0
              end
            end)
            |> Enum.sum() == 0

          down =
            Enum.map((row + 1)..rows-1, fn row ->
              tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()

              if tmp >= value do
                1
              else
                0
              end
            end)
            |> Enum.sum() == 0

          if left || right || up || down do
            1
          else
            0
          end
        end
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end


defmodule Part2 do
  def run() do
    trees =
      File.read!("input.txt")
      |> String.split("\n")
      |> Enum.map(&String.graphemes(&1))

    rows = length(trees)
    cols = length(List.first(trees))

    Enum.map(0..(rows - 1), fn row ->
      Enum.map(0..(cols - 1), fn col ->
        value = trees |> Enum.at(row) |> Enum.at(col) |> String.to_integer()

        left =
          Enum.reduce_while(max(col - 1, 0)..0, 0, fn col, acc ->
            tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()
            if tmp >= value do
              {:halt, acc+1}
            else
              {:cont, acc+1}
            end
          end)

        right =
          Enum.reduce_while(min(cols-1, col + 1)..cols-1, 0, fn col, acc ->
            tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()
            if tmp >= value do
              {:halt, acc+1}
            else
              {:cont, acc+1}
            end
          end)

        up =
          Enum.reduce_while(max(row - 1, 0)..0, 0, fn row, acc ->
            tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()
            if tmp >= value do
              {:halt, acc+1}
            else
              {:cont, acc+1}
            end
          end)

        down =
          Enum.reduce_while(min(rows-1, row + 1)..rows-1, 0, fn row, acc ->
            tmp = Enum.at(trees, row) |> Enum.at(col) |> String.to_integer()
            if tmp >= value do
              {:halt, acc+1}
            else
              {:cont, acc+1}
            end
          end)

        left * right * down * up
      end)
      |> Enum.max()
    end)
    |> Enum.max()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
