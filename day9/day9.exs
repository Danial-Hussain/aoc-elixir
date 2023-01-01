defmodule Shared do
  def updateTail({new_hp, tp, tv}) do
    same_row = new_hp |> elem(0) == tp |> elem(0)
    same_col = new_hp |> elem(1) == tp |> elem(1)

    touching = max(
      abs((new_hp |> elem(0)) - (tp |> elem(0))),
      abs((new_hp |> elem(1)) - (tp |> elem(1)))
    ) <= 1

    cond do
      !touching && !same_row && !same_col  ->
        new_tp = cond do
          (new_hp |> elem(0)) > (tp |> elem(0)) &&
          (new_hp |> elem(1)) > (tp |> elem(1)) ->
            {x, y} = tp
            {x+1, y+1}
          (new_hp |> elem(0)) < (tp |> elem(0)) &&
          (new_hp |> elem(1)) < (tp |> elem(1)) ->
            {x, y} = tp
            {x-1, y-1}
          (new_hp |> elem(0)) > (tp |> elem(0)) ->
            {x, y} = tp
            {x+1, y-1}
          (new_hp |> elem(0)) < (tp |> elem(0)) ->
            {x, y} = tp
            {x-1, y+1}
        end
        new_tv = MapSet.put(tv, new_tp)
        {new_tp, new_tv}

      !touching ->
        new_tp = cond do
          (new_hp |> elem(0)) > (tp |> elem(0)) ->
            {x, y} = tp
            {x+1, y}
          (new_hp |> elem(0)) < (tp |> elem(0)) ->
            {x, y} = tp
            {x-1, y}
          (new_hp |> elem(1)) > (tp |> elem(1)) ->
            {x, y} = tp
            {x, y+1}
          (new_hp |> elem(1)) < (tp |> elem(1)) ->
            {x, y} = tp
            {x, y-1}
        end
        new_tv = MapSet.put(tv, new_tp)
        {new_tp, new_tv}

      true ->
        {tp, tv}
    end
  end

  def part1() do
    movements = File.read!("input.txt") |> String.split("\n")
    hp = {0, 0}
    tp = {0, 0}
    tv = MapSet.new([tp])

    Enum.reduce(movements, {hp, tp, tv}, fn movement, {hp, tp, tv} ->
      movement_split = String.split(movement, " ")
      direction = movement_split |> List.first()
      steps = movement_split |> List.last() |> String.to_integer()

      Enum.reduce(1..steps, {hp, tp, tv}, fn _, {hp, tp, tv} ->
        new_hp = case direction do
          "L" ->
            {x, y} = hp
            {x-1, y}
          "R" ->
            {x, y} = hp
            {x+1, y}
          "U" ->
            {x, y} = hp
            {x, y+1}
          "D" ->
            {x, y} = hp
            {x, y-1}
        end
        {new_tp, new_tv} = updateTail({new_hp, tp, tv})
        {new_hp, new_tp, new_tv}
      end)
    end)
    |> elem(2)
    |> MapSet.size()
    |> IO.inspect()
  end
end

Shared.part1()
