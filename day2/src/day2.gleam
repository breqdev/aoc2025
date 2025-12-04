import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

fn sum_invalid_ids_part1(start: Int, end: Int) -> Int {
  let num_digits_start = string.length(int.to_string(start))
  let num_digits_end = string.length(int.to_string(end))

  case num_digits_start == num_digits_end {
    True -> {
      case num_digits_end % 2 {
        0 -> {
          let assert Ok(divisor) =
            int.power(10, int.to_float(num_digits_end / 2))
          let divisor = float.truncate(divisor)

          let start_prefix = start / divisor
          let end_prefix = end / divisor

          list.range(start_prefix, end_prefix)
          |> list.map(fn(first_half) {
            let candidate = first_half * divisor + first_half

            case start <= candidate && candidate <= end {
              True -> candidate
              False -> 0
            }
          })
          |> list.fold(0, int.add)
        }
        1 -> {
          0
        }
        _ -> panic
      }
    }
    False -> {
      let assert Ok(high_range_start) =
        int.power(10, int.to_float(num_digits_end - 1))
      let high_range_start = float.truncate(high_range_start)
      let low_range_end = high_range_start - 1

      sum_invalid_ids_part1(start, low_range_end)
      + sum_invalid_ids_part1(high_range_start, end)
    }
  }
}

pub fn part_1(input: String) -> String {
  input
  |> string.split(",")
  |> list.map(fn(range) {
    range
    |> string.trim
    |> string.split("-")
    |> list.map(fn(idx) {
      let assert Ok(result) = int.parse(idx)
      result
    })
    |> fn(pair) {
      let assert [first, last] = pair
      #(first, last)
    }
  })
  |> list.map(fn(range) { sum_invalid_ids_part1(range.0, range.1) })
  |> list.fold(0, int.add)
  |> int.to_string
}

fn sum_invalid_ids_part2(start: Int, end: Int) -> Int {
  let num_digits_start = string.length(int.to_string(start))
  let num_digits_end = string.length(int.to_string(end))

  case num_digits_start == num_digits_end {
    True -> {
      let num_digits = num_digits_start

      case num_digits {
        0 -> 0
        1 -> 0
        _ ->
          list.range(1, num_digits / 2)
          |> list.map(fn(chunk_size) {
            case num_digits % chunk_size {
              0 -> {
                let num_chunks = num_digits / chunk_size
                let length_tail = { num_chunks - 1 } * chunk_size

                let assert Ok(divisor) =
                  int.power(10, int.to_float(length_tail))
                let divisor = float.truncate(divisor)

                let start_prefix = start / divisor
                let end_prefix = end / divisor

                list.range(start_prefix, end_prefix)
                |> list.map(fn(prefix) {
                  let assert Ok(candidate) =
                    int.parse(string.repeat(int.to_string(prefix), num_chunks))

                  case start <= candidate && candidate <= end {
                    True -> candidate
                    False -> 0
                  }
                })
              }
              _ -> []
            }
          })
          |> list.flatten
          |> list.unique
          |> list.fold(0, int.add)
      }
    }
    False -> {
      let assert Ok(high_range_start) =
        int.power(10, int.to_float(num_digits_end - 1))
      let high_range_start = float.truncate(high_range_start)
      let low_range_end = high_range_start - 1

      sum_invalid_ids_part2(start, low_range_end)
      + sum_invalid_ids_part2(high_range_start, end)
    }
  }
}

pub fn part_2(input: String) -> String {
  input
  |> string.split(",")
  |> list.map(fn(range) {
    range
    |> string.trim
    |> string.split("-")
    |> list.map(fn(idx) {
      let assert Ok(result) = int.parse(idx)
      result
    })
    |> fn(pair) {
      let assert [first, last] = pair
      #(first, last)
    }
  })
  |> list.map(fn(range) { sum_invalid_ids_part2(range.0, range.1) })
  |> list.fold(0, int.add)
  |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
