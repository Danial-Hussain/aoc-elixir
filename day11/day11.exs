defmodule Shared do
  def parse() do
    input =
      File.read!("input.txt")
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
      |> Enum.chunk_every(6)

    Enum.reduce(input, %{}, fn i, monkeys ->
      m =
        i
        |> Enum.at(0)
        |> String.split("Monkey ")
        |> Enum.at(1)
        |> String.split(":")
        |> Enum.at(0)

      op =
        i
        |> Enum.at(2)
        |> String.split("= ")
        |> Enum.at(-1)

      items =
        i
        |> Enum.at(1)
        |> String.split(": ")
        |> Enum.at(1)
        |> String.split(", ")

      test =
        i
        |> Enum.at(3)
        |> String.split(" ")
        |> Enum.at(-1)
        |> String.to_integer()

      if_true =
        i
        |> Enum.at(4)
        |> String.split(" ")
        |> Enum.at(-1)

      if_false =
        i
        |> Enum.at(5)
        |> String.split(" ")
        |> Enum.at(-1)

      Map.put(monkeys, m, %{
        "inspected" => 0,
        "operation" => op,
        "items" => items,
        "test" => test,
        "if_true" => if_true,
        "if_false" => if_false
      })
    end)
  end
end

defmodule Part1 do
  def run() do
    monkeys = Shared.parse()
    monkeys_cnt = monkeys |> map_size()
    iterations = 20 * monkeys_cnt

    Enum.reduce(0..iterations, monkeys, fn i, monkeys ->
      current_mon = rem(i, monkeys_cnt)
      current_key = Integer.to_string(current_mon)
      items_count = monkeys[current_key]["items"] |> length()

      Enum.reduce(0..(items_count - 1), monkeys, fn _, monkeys ->
        items = monkeys[current_key]["items"]

        if length(items) != 0 do
          test = monkeys[current_key]["test"]
          item = items |> Enum.at(0) |> String.to_integer()
          inspected = monkeys[current_key]["inspected"]

          operation = monkeys[current_key]["operation"]
          operation_split = operation |> String.split(" ")
          operator = operation_split |> Enum.at(1)

          first_val =
            if operation_split |> Enum.at(0) == "old" do
              item
            else
              String.to_integer(operation_split |> Enum.at(0))
            end

          second_val =
            if operation_split |> Enum.at(2) == "old" do
              item
            else
              String.to_integer(operation_split |> Enum.at(2))
            end

          new_item =
            if operator == "*" do
              Float.floor(first_val * second_val / 3) |> round()
            else
              Float.floor((first_val + second_val) / 3) |> round()
            end

          {to_key, new_map} =
            if rem(new_item, test) == 0 do
              to_key = monkeys[current_key]["if_true"]
              to_map = monkeys[to_key]
              str_item = new_item |> Integer.to_string()
              {to_key, %{to_map | "items" => to_map["items"] ++ [str_item]}}
            else
              to_key = monkeys[current_key]["if_false"]
              to_map = monkeys[to_key]
              str_item = new_item |> Integer.to_string()
              {to_key, %{to_map | "items" => to_map["items"] ++ [str_item]}}
            end

          %{
            monkeys
            | to_key => new_map,
              current_key => %{
                monkeys[current_key]
                | "inspected" => inspected + 1,
                  "items" => items |> Enum.split(1) |> elem(1)
              }
          }
        else
          monkeys
        end
      end)
    end)
    |> Map.values()
    |> Enum.map(& &1["inspected"])
    |> Enum.sort(:desc)
    |> Enum.slice(0..1)
    |> Enum.product()
    |> IO.inspect()
  end
end

Part1.run()
