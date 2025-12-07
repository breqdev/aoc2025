import gleam/set
import gleam/int
import gleam/list
import gleam/string
import gleam/io
import simplifile.{read}
import tote/bag

fn parse_grid(input: String) -> List(String) {
  input |> string.split("\n") |> list.filter(fn(line) {!string.is_empty(line)})
}

pub fn part_1(input: String) -> String {
  let grid = parse_grid(input)

  let assert Ok(first) = list.first(grid)
  let assert [start_x] = first |> string.to_graphemes |> list.index_map(fn(x, i) {#(x, i)}) |> list.filter_map(fn(item) {
    let #(x, i) = item
    case x == "S" {
      True -> Ok(i)
      False -> Error(Nil)
    }
  })

  let beams = set.insert(set.new(), start_x)

  let #(_beams, count) = grid |> list.fold(#(beams, 0), fn(acc, row) {
    let #(beams, count) = acc

    beams |> set.to_list |> list.map(fn(beam) {
      // this beam might become one or two beams

      case string.slice(row, beam, 1) {
        "." | "S" -> #(set.from_list([beam]), 0)
        "^" -> #(set.from_list([beam - 1, beam + 1]), 1)
        _ -> panic
      }
    }) |> list.fold(#(set.new(), count), fn(acc, new) {
      let #(beams, count) = acc
      let #(new_beams, new_count) = new

      #(set.union(beams, new_beams), count + new_count)
    })
  })

  count |> int.to_string
}


pub fn part_2(input: String) -> String {
  let grid = parse_grid(input)

  let assert Ok(first) = list.first(grid)
  let assert [start_x] = first |> string.to_graphemes |> list.index_map(fn(x, i) {#(x, i)}) |> list.filter_map(fn(item) {
    let #(x, i) = item
    case x == "S" {
      True -> Ok(i)
      False -> Error(Nil)
    }
  })

  let beams = bag.from_list([start_x])

  let #(_beams, count) = grid |> list.fold(#(beams, 1), fn(acc, row) {
    let #(beams, count) = acc

    beams |> bag.to_list |> list.map(fn(bag) {
      // this beam might become one or two beams
      let #(beam, qty) = bag

      case string.slice(row, beam, 1) {
        "." | "S" -> {
          let result = bag.new() |> bag.update(beam, fn(_) {qty})
          #(result, 0)
        }
        "^" -> {
          let result = bag.new() |> bag.update(beam - 1, fn(_) {qty}) |> bag.update(beam + 1, fn(_){qty})

          #(result, qty)
        }
        _ -> panic
      }
    }) |> list.fold(#(bag.new(), count), fn(acc, new) {
      let #(beams, count) = acc
      let #(new_beams, new_count) = new

      #(bag.merge(beams, new_beams), count + new_count)
    })
  })

  count |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
