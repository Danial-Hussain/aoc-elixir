defmodule Shared do
  def create_filesystem() do
    commands =
      File.read!("input.txt")
      |> String.split("\n", trim: true)

    fs = %{"/" => 0}
    ds = []

    Enum.reduce(commands, {fs, ds}, fn cmd, {fs, ds} ->
      cmd_split = String.split(cmd, " ")

      is_cmd = cmd_split |> List.first() == "$"
      is_cd = is_cmd && cmd_split |> Enum.at(1) == "cd"
      is_ls = is_cmd && cmd_split |> Enum.at(1) == "ls"

      cond do
        is_cd ->
          case cmd_split |> Enum.at(2) do
            "/" -> {fs, ["/"]}
            ".." -> {fs, List.delete_at(ds, length(ds) - 1)}
            _ -> {fs, ds ++ [cmd_split |> Enum.at(2)]}
          end

        is_ls ->
          {fs, ds}

        true ->
          is_dir = cmd_split |> List.first() == "dir"

          if is_dir do
            {fs, ds}
          else
            points = cmd_split |> List.first() |> String.to_integer()

            fs_new =
              Enum.reduce(0..(length(ds) - 1), fs, fn i, fs ->
                path = ds |> Enum.slice(0..i) |> Enum.join("/")
                Map.update(fs, path, points, &(&1 + points))
              end)

            {fs_new, ds}
          end
      end
    end)
  end
end

defmodule Part1 do
  def run() do
    result = Shared.create_filesystem()

    result
    |> elem(0)
    |> Map.values()
    |> Enum.reject(&(&1 > 100_000))
    |> Enum.sum()
    |> IO.inspect()
  end
end

defmodule Part2 do
  def run() do
    result = Shared.create_filesystem()

    used_space =
      result
      |> elem(0)
      |> Map.values()
      |> Enum.sort(:desc)
      |> List.first()

    unused_space = 70_000_000 - used_space
    needed_space = 30_000_000 - unused_space

    result
    |> elem(0)
    |> Map.values()
    |> Enum.reject(&(&1 < needed_space))
    |> Enum.sort()
    |> List.first()
    |> IO.inspect()
  end
end

Part1.run()
Part2.run()
