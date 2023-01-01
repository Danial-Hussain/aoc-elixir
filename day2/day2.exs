defmodule Part1 do
  def run() do
    point_map = %{"X" => 1, "Y" => 2, "Z" => 3}

    outcome_map = %{
      "A X" => 3,
      "B Y" => 3,
      "C Z" => 3,
      "A Y" => 6,
      "B Z" => 6,
      "C X" => 6,
      "B X" => 0,
      "C Y" => 0,
      "A Z" => 0
    }

    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&(point_map[String.at(&1, 2)] + outcome_map[&1]))
    |> Enum.sum()
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    point_map = %{"X" => 0, "Y" => 3, "Z" => 6}

    outcome_map = %{
      "A X" => 3,
      "B Y" => 2,
      "C Z" => 1,
      "A Y" => 1,
      "B Z" => 3,
      "C X" => 2,
      "B X" => 1,
      "C Y" => 3,
      "A Z" => 2
    }

    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&(point_map[String.at(&1, 2)] + outcome_map[&1]))
    |> Enum.sum()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
