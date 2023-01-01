defmodule Part1 do
  use Agent

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def is_oob(rows, cols, {r, c}) do
    if r < 0 || r >= rows || c < 0 || c >= cols do
      true
    else
      false
    end
  end

  def shortest_path(heightmap, {sr, sc}, {er, ec}, steps) do
    rows = heightmap |> length()
    cols = heightmap |> Enum.at(0) |> length()

    memo = Agent.get(__MODULE__, &Map.get(&1, {sr, sc}))

    if memo != nil do
      memo + steps
    else
      min_steps =
        Enum.map([{1, 0}, {0, 1}, {-1, 0}, {0, -1}], fn {new_r, new_c} ->
          new_coords = {sr + new_r, sc + new_c}

          cond do
            is_oob(rows, cols, new_coords) ->
              :infinity

            new_coords == {er, ec} ->
              steps + 1

            true ->
              prev_val =
                heightmap
                |> Enum.at(sr)
                |> Enum.at(sc)

              new_val =
                heightmap
                |> Enum.at(new_coords |> elem(0))
                |> Enum.at(new_coords |> elem(1))

              <<pv::utf8>> =
                if prev_val == "S" do
                  "a"
                else
                  prev_val
                end

              <<nv::utf8>> =
                if new_val == "E" do
                  "z"
                else
                  new_val
                end

              if nv < pv || abs(pv - nv) <= 1 do
                shortest_path(heightmap, new_coords, {er, ec}, steps + 1)
              else
                :infinity
              end
          end
        end)
        |> Enum.min()

      Agent.update(__MODULE__, &Map.put(&1, {sr, sc}, min_steps))
      min_steps
    end
  end

  def run do
    heightmap =
      File.read!("input.txt")
      |> String.split("\n")
      |> Enum.map(&String.graphemes(&1))

    start_coords =
      heightmap
      |> Enum.with_index()
      |> Enum.map(fn {row, index} ->
        {index, Enum.find_index(row, &(&1 == "S"))}
      end)
      |> Enum.reject(&(&1 |> elem(1) == nil))
      |> Enum.at(0)

    end_coords =
      heightmap
      |> Enum.with_index()
      |> Enum.map(fn {row, index} ->
        {index, Enum.find_index(row, &(&1 == "E"))}
      end)
      |> Enum.reject(&(&1 |> elem(1) == nil))
      |> Enum.at(0)

    {:ok, _} = Part1.start()
    sp = shortest_path(heightmap, start_coords, end_coords, 0)
    IO.inspect(sp)
  end
end

Part1.run()
