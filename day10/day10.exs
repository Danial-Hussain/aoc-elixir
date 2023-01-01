defmodule Part1 do
  def run() do
    instructions =
      File.read!("input.txt")
      |> String.split("\n", trim: true)

    cycles = MapSet.new([20, 60, 100, 140, 180, 220])

    Enum.reduce(instructions, {1, 1, 0}, fn instruction, {x, cycle, strength} ->
      if instruction == "noop" do
        new_strength =
          if cycle in cycles do
            strength + cycle * x
          else
            strength
          end

        {x, cycle + 1, new_strength}
      else
        new_strength =
          if cycle in cycles do
            strength + cycle * x
          else
            strength
          end

        new_strength =
          if (cycle + 1) in cycles do
            new_strength + (cycle + 1) * x
          else
            new_strength
          end

        v =
          String.split(instruction, " ")
          |> Enum.at(1)
          |> String.to_integer()

        {x + v, cycle + 2, new_strength}
      end
    end)
    |> elem(2)
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    instructions =
      File.read!("input.txt")
      |> String.split("\n", trim: true)

    Enum.reduce(instructions, {1, 0, 0, ""}, fn instruction, {x_pos, c_pos, cycle, c_val} ->
      if instruction == "noop" do
        new_cpos =
          if c_pos > 39 do
            c_pos - 40
          else
            c_pos
          end

        new_cval =
          if abs(x_pos - new_cpos) <= 1 do
            "#{c_val}#"
          else
            "#{c_val}."
          end

        {x_pos, new_cpos + 1, cycle + 1, new_cval}
      else
        new_cpos =
          if c_pos > 39 do
            c_pos - 40
          else
            c_pos
          end

        new_cval =
          if abs(x_pos - new_cpos) <= 1 do
            "#{c_val}#"
          else
            "#{c_val}."
          end

        new_cpos =
          if new_cpos + 1 > 39 do
            0
          else
            new_cpos + 1
          end

        new_cval =
          if abs(x_pos - new_cpos) <= 1 do
            "#{new_cval}#"
          else
            "#{new_cval}."
          end

        v =
          String.split(instruction, " ")
          |> Enum.at(1)
          |> String.to_integer()

        {x_pos + v, c_pos + 2, cycle + 2, new_cval}
      end
    end)
    |> elem(3)
    |> String.codepoints()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
