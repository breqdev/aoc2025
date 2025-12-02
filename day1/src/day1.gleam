import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

pub fn part_1(input: String) -> String {
  let lines = string.split(input, on: "\n")

  let steps =
    list.filter_map(lines, fn(line) {
      let line = string.trim(line)

      case string.is_empty(line) {
        False -> {
          let assert Ok(#(head, tail)) = string.pop_grapheme(line)
          let assert Ok(num) = int.parse(tail)
          Ok(#(head, num))
        }
        True -> {
          Error(Nil)
        }
      }
    })

  let result =
    list.fold(steps, #(50, 0), fn(acc, val) {
      let #(direction, steps) = val
      let #(dial, count) = acc

      let dial = case direction {
        "L" -> {
          dial - steps
        }
        "R" -> {
          dial + steps
        }
        _ -> {
          panic as "unknown direction"
        }
      }

      let assert Ok(dial) = int.modulo(dial, 100)

      let count = case dial {
        0 -> count + 1
        _ -> count
      }

      #(dial, count)
    })

  let #(_dial, count) = result

  int.to_string(count)
}

pub fn part_2(input: String) -> String {
  let lines = string.split(input, on: "\n")

  let steps =
    list.filter_map(lines, fn(line) {
      let line = string.trim(line)

      case string.is_empty(line) {
        False -> {
          let assert Ok(#(head, tail)) = string.pop_grapheme(line)
          let assert Ok(num) = int.parse(tail)
          Ok(#(head, num))
        }
        True -> {
          Error(Nil)
        }
      }
    })

  let result =
    list.fold(steps, #(50, 0), fn(acc, val) {
      let #(direction, steps) = val
      let #(dial, count) = acc

      let #(new_dial, zero_crossings) = case direction {
        "L" -> {
          let new_dial = dial - steps

          let start = case dial {
            0 -> 0
            _ -> 100
          }

          let assert Ok(zero_crossings) =
            int.floor_divide(start - new_dial, 100)

          #(new_dial, zero_crossings)
        }
        "R" -> {
          let new_dial = dial + steps
          let assert Ok(zero_crossings) = int.floor_divide(new_dial, 100)

          #(new_dial, zero_crossings)
        }
        _ -> {
          panic as "unknown direction"
        }
      }

      let assert Ok(new_dial) = int.modulo(new_dial, 100)

      #(new_dial, count + zero_crossings)
    })

  let #(_dial, count) = result

  int.to_string(count)
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
