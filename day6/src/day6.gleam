import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string
import simplifile.{read}

fn get_columns(input: String) -> List(List(String)) {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.map(fn(line) { string.append(line, " ") })

  let max_length = lines |> list.map(string.length) |> list.fold(0, int.max)

  let assert Ok(space_indices) =
    lines
    |> list.map(fn(line) {
      line
      |> string.to_graphemes
      |> list.index_map(fn(x, i) { #(x, i) })
      |> list.filter(fn(item) {
        let #(char, _idx) = item
        char == " "
      })
      |> list.map(fn(item) {
        let #(_char, idx) = item
        idx + 1
      })
      |> set.from_list
    })
    |> list.reduce(set.intersection)

  let column_indices =
    space_indices
    |> set.to_list
    |> list.sort(int.compare)
    |> list.prepend(0)
    |> list.append([max_length])
    |> list.window(2)

  column_indices
  |> list.map(fn(index_pair) {
    let assert [start, end] = index_pair

    lines
    |> list.map(fn(line) { string.slice(line, start, end - start) })
  })
}

fn get_operation(opcode: String) -> fn(List(Int)) -> Int {
  case string.trim(opcode) {
    "+" -> {
      fn(operands) { list.fold(operands, 0, int.add) }
    }
    "*" -> {
      fn(operands) { list.fold(operands, 1, int.multiply) }
    }
    _ -> panic
  }
}

pub fn part_1(input: String) -> String {
  let columns = get_columns(input)

  let results =
    columns
    |> list.map(fn(column) {
      let assert Ok(opcode) = list.last(column)
      let operands = list.take(column, list.length(column) - 1)

      let operation = get_operation(opcode)

      operands
      |> list.map(fn(operand) {
        let assert Ok(result) = int.parse(string.trim(operand))
        result
      })
      |> operation
    })

  results |> int.sum |> int.to_string
}

pub fn part_2(input: String) -> String {
  let columns = get_columns(input)

  let results =
    columns
    |> list.map(fn(column) {
      let assert Ok(opcode) = list.last(column)
      let operands = list.take(column, list.length(column) - 1)

      let operation = get_operation(opcode)

      let operand_length =
        operands |> list.map(string.length) |> list.fold(0, int.max)

      let operands =
        list.range(0, operand_length - 2)
        |> list.map(fn(idx) {
          let assert Ok(result) =
            operands
            |> list.map(fn(line) { string.slice(line, idx, 1) })
            |> string.concat
            |> string.trim
            |> int.parse
          result
        })

      operands |> operation
    })

  results |> int.sum |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
