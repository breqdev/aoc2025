import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

fn parse_ranges(input: String) -> List(#(Int, Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(range) {
    let assert [start, end] = string.split(range, "-")
    let assert Ok(start) = int.parse(start)
    let assert Ok(end) = int.parse(end)

    #(start, end)
  })
}

fn contained_in_range(ingredient: Int, ranges: List(#(Int, Int))) -> Bool {
  ranges
  |> list.any(fn(range) {
    let #(start, end) = range
    start <= ingredient && ingredient <= end
  })
}

pub fn part_1(input: String) -> String {
  let assert [ranges, ingredients] = string.split(input, "\n\n")

  let ranges = parse_ranges(ranges)

  let ingredients =
    ingredients |> string.split("\n") |> list.filter_map(int.parse)

  ingredients
  |> list.count(fn(id) { contained_in_range(id, ranges) })
  |> int.to_string
}

pub fn part_2(input: String) -> String {
  let assert [ranges, _ingredients] = string.split(input, "\n\n")
  let ranges = parse_ranges(ranges)

  let highest =
    ranges
    |> list.map(fn(range) {
      let #(_start, end) = range
      end
    })
    |> list.fold(0, int.max)

  list.range(0, highest)
  |> list.count(fn(id) { contained_in_range(id, ranges) })
  |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
