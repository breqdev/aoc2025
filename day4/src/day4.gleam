import simplifile.{read}
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn parse_grid(grid: String) -> Dict(#(Int, Int), Bool) {
  grid
  |> string.split("\n")
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(string.to_graphemes)
  |> list.index_map(fn(row, y) {
    row
    |> list.index_map(fn(char, x) {
      let key = #(x, y)
      let val = case char {
        "." -> False
        "@" -> True
        _ -> panic
      }
      #(key, val)
    })
    |> list.fold(dict.new(), fn(acc, entry) {
      let #(key, val) = entry
      dict.insert(acc, key, val)
    })
  })
  |> list.fold(dict.new(), dict.merge)
}

pub fn remove_rolls(grid: Dict(#(Int, Int), Bool)) -> #(Dict(#(Int, Int), Bool), Int) {
  dict.fold(grid, #(dict.new(), 0), fn(acc, pos, value) {
    let #(next, total) = acc

    case value {
      True -> {
        // check the eight adjacent positions
        let #(x, y) = pos
        let neighbors = [
          #(x - 1, y - 1),
          #(x, y - 1),
          #(x + 1, y - 1),
          #(x - 1, y),
          #(x + 1, y),
          #(x - 1, y + 1),
          #(x, y + 1),
          #(x + 1, y + 1),
        ]

        let neighbor_rolls =
          neighbors
          |> list.map(fn(pos) {
            case dict.get(grid, pos) {
              Ok(True) -> 1
              // paper roll
              Ok(False) -> 0
              // empty space
              Error(_) -> 0
              // out of bounds
            }
          })
          |> list.fold(0, int.add)

        case neighbor_rolls < 4 {
          // accessible! let's remove it
          True -> #(dict.insert(next, pos, False), total + 1)

          // not accessible, keep it
          False -> #(dict.insert(next, pos, True), total)
        }
      }
      False -> #(dict.insert(next, pos, False), total)
      // not a paper roll location, keep empty
    }
  })
}

pub fn part_1(input: String) -> String {
  let grid = parse_grid(input)
  let #(_new_grid, total) = remove_rolls(grid)

  int.to_string(total)
}

fn remove_recursively(grid, total) -> #(Dict(#(Int, Int), Bool), Int) {
  let #(new_grid, amount_removed) = remove_rolls(grid)

  case amount_removed {
    // not able to remove this iteration
    0 -> #(grid, total)

    // we can remove!
    _ -> remove_recursively(new_grid, total + amount_removed)
  }
}

pub fn part_2(input: String) -> String {
  let grid = parse_grid(input)
  let #(_new_grid, total) = remove_recursively(grid, 0)

  int.to_string(total)
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
