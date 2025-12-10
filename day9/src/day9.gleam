import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

pub fn part_1(input: String) -> String {
  let coordinates =
    input
    |> string.split("\n")
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.map(fn(line) {
      let assert [x, y] = string.split(line, ",")
      let assert Ok(x) = int.parse(x)
      let assert Ok(y) = int.parse(y)
      #(x, y)
    })

  let assert Ok(largest) =
    coordinates
    |> list.combination_pairs
    |> list.map(fn(pair) {
      let #(first, second) = pair
      let #(x1, y1) = first
      let #(x2, y2) = second

      { x1 - x2 + 1 } * { y1 - y2 + 1 }
    })
    |> list.max(int.compare)

  largest |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_1(input)
  io.println(result)
}
