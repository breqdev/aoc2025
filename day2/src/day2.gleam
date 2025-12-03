import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

fn sum_invalid_ids(start: Int, end: Int) -> Int {
  let num_digits_start = string.length(int.to_string(start))
  let num_digits_end = string.length(int.to_string(end))

  case num_digits_start == num_digits_end {
    True -> {
      case num_digits_end % 2 {
        0 -> {
          let assert Ok(divisor) =
            int.power(10, int.to_float(num_digits_end / 2))
          let divisor = float.truncate(divisor)

          let start_first_half = start / divisor
          let end_first_half = end / divisor

          list.range(start_first_half, end_first_half)
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

      sum_invalid_ids(start, low_range_end)
      + sum_invalid_ids(high_range_start, end)
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
  |> list.map(fn(range) { sum_invalid_ids(range.0, range.1) })
  |> list.fold(0, int.add)
  |> int.to_string
}

pub fn is_invalid(id: Int) {
  let num_digits = string.length(int.to_string(id))

  case num_digits {
    0 -> False
    1 -> False
    _ ->
      list.range(1, num_digits / 2)
      |> list.any(fn(chunk_size) {
        case num_digits % chunk_size {
          0 -> {
            let target = string.slice(int.to_string(id), 0, chunk_size)

            list.range(0, num_digits / chunk_size - 1)
            |> list.all(fn(chunk_idx) {
              let chunk =
                string.slice(
                  int.to_string(id),
                  chunk_idx * chunk_size,
                  chunk_size,
                )

              target == chunk
            })
          }
          _ -> False
        }
      })
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
  |> list.map(fn(range) {
    list.range(range.0, range.1)
    |> list.filter(is_invalid)
    |> list.fold(0, int.add)
  })
  |> list.fold(0, int.add)
  |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2(input)
  io.println(result)
}
