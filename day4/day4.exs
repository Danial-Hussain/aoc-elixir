defmodule Part1 do
  def run() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(
      &(String.split(&1, ",")
        |> Enum.map(fn val -> String.split(val, "-") end))
    )
    |> Enum.map(fn val ->
      s1_i1 = Enum.at(val, 0) |> Enum.at(0) |> String.to_integer()
      s1_i2 = Enum.at(val, 0) |> Enum.at(1) |> String.to_integer()
      s2_i1 = Enum.at(val, 1) |> Enum.at(0) |> String.to_integer()
      s2_i2 = Enum.at(val, 1) |> Enum.at(1) |> String.to_integer()

      if (s1_i1 >= s2_i1 && s1_i2 <= s2_i2) ||
           (s2_i1 >= s1_i1 && s2_i2 <= s1_i2) do
        1
      else
        0
      end
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(
      &(String.split(&1, ",")
        |> Enum.map(fn val -> String.split(val, "-") end))
    )
    |> Enum.map(fn val ->
      s1_i1 = Enum.at(val, 0) |> Enum.at(0) |> String.to_integer()
      s1_i2 = Enum.at(val, 0) |> Enum.at(1) |> String.to_integer()
      s2_i1 = Enum.at(val, 1) |> Enum.at(0) |> String.to_integer()
      s2_i2 = Enum.at(val, 1) |> Enum.at(1) |> String.to_integer()

      if (s1_i1 >= s2_i1 && s1_i1 <= s2_i2) ||
           (s2_i1 >= s1_i1 && s2_i2 <= s1_i2) ||
           (s1_i2 <= s2_i2 && s1_i2 >= s2_i1) ||
           (s2_i2 <= s1_i2 && s2_i2 >= s1_i1) do
        1
      else
        0
      end
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
