import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleam/dict.{type Dict}
import simplifile.{read}

pub fn best_joltage_2(bank: List(Int)) -> Int {
  case list.length(bank) {
    0 -> panic
    1 -> panic
    2 -> {
      // only one solution -- the two digits in order
      let assert Ok(first) = list.first(bank)
      let assert Ok(rest) = list.rest(bank)
      let assert Ok(second) = list.first(rest)
      let result = int.to_string(first) <> int.to_string(second)
      let assert Ok(result) = int.parse(result)
      result
    }
    _ -> {
      // recursive approach
      let assert Ok(first) = list.first(bank)
      let assert Ok(rest) = list.rest(bank)

      rest
      |> list.map(fn(second) {
        let result = int.to_string(first) <> int.to_string(second)
        let assert Ok(result) = int.parse(result)
        result
      })
      |> list.fold(best_joltage_2(rest), int.max)
    }
  }
}

pub fn best_joltage_n(bank: List(Int), n: Int) -> Int {
  case n {
    // zero -- problem not well defined
    0 -> panic

    // n = 1 -- just find the highest digit, or 0 if none exists
    1 -> {
      bank |> list.fold(0, int.max)
    }

    // n > 1 -- recurse!
    _ -> {
      case list.length(bank) {
        // not valid
        0 -> panic
        // no solutions
        1 -> panic

        _ -> case list.length(bank) {
          i if i < n -> panic
          i if i == n -> {
            // we are required to take the first digit
            let assert Ok(first) = list.first(bank)
            let assert Ok(rest) = list.rest(bank)

            // multiply first by 10^(n-1) to shift left
            let assert Ok(multiplier) = int.power(10, int.to_float(n - 1))
            let multiplier = float.truncate(multiplier)

            first * multiplier + best_joltage_n(rest, n - 1)
          }
          i if i > n -> {
            // we can either take or skip the first digit
            let assert Ok(first) = list.first(bank)
            let assert Ok(rest) = list.rest(bank)

            let if_we_skip = best_joltage_n(rest, n)

            // multiply first by 10^(n-1) to shift left
            let assert Ok(multiplier) = int.power(10, int.to_float(n - 1))
            let multiplier = float.truncate(multiplier)

            let if_we_include = first * multiplier + best_joltage_n(rest, n - 1)

            int.max(if_we_skip, if_we_include)
          }
          _ -> panic
        }
      }
    }
  }
}

pub fn best_joltage_n_cached(bank: List(Int), n: Int, cache: Dict(#(List(Int), Int), Int)) -> #(Int, Dict(#(List(Int), Int), Int)) {
  let cached = dict.get(cache, #(bank, n))

  case cached {
    Ok(val) -> {
      #(val, cache)
    }
    Error(_) -> {
      // compute it!

      case n {
        // zero -- problem not well defined
        0 -> panic

        // n = 1 -- just find the highest digit, or 0 if none exists
        1 -> {
          let result = bank |> list.fold(0, int.max)
          let cache = dict.insert(cache, #(bank, n), result)

          #(result, cache)
        }

        // n > 1 -- recurse!
        _ -> {
          case list.length(bank) {
            // not valid
            0 -> panic
            // no solutions
            1 -> panic

            _ -> case list.length(bank) {
              i if i < n -> panic
              i if i == n -> {
                // we are required to take the first digit
                let assert Ok(first) = list.first(bank)
                let assert Ok(rest) = list.rest(bank)

                // multiply first by 10^(n-1) to shift left
                let assert Ok(multiplier) = int.power(10, int.to_float(n - 1))
                let multiplier = float.truncate(multiplier)

                let #(if_we_include, cache) = best_joltage_n_cached(rest, n - 1, cache)
                let result = first * multiplier + if_we_include
                let cache = dict.insert(cache, #(bank, n), result)

                #(result, cache)
              }
              i if i > n -> {
                // we can either take or skip the first digit
                let assert Ok(first) = list.first(bank)
                let assert Ok(rest) = list.rest(bank)

                let #(if_we_skip, cache) = best_joltage_n_cached(rest, n, cache)

                // multiply first by 10^(n-1) to shift left
                let assert Ok(multiplier) = int.power(10, int.to_float(n - 1))
                let multiplier = float.truncate(multiplier)

                let #(if_we_include, cache) = best_joltage_n_cached(rest, n - 1, cache)
                let if_we_include = first * multiplier + if_we_include

                let result = int.max(if_we_skip, if_we_include)
                let cache = dict.insert(cache, #(bank, n), result)
                #(result, cache)
              }
              _ -> panic
            }
          }
        }
      }
    }
  }
}


pub fn part_1(input: String) -> String {
  input
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(string.to_graphemes)
  |> list.map(fn(bank) {
    list.map(bank, fn(digit) {
      let assert Ok(digit) = int.parse(digit)
      digit
    })
  })
  // cool, now we have a list of banks, each one a list of batteries
  // let's find the optimal one for each battery
  |> list.map(best_joltage_2)
  |> list.fold(0, int.add)
  |> int.to_string
}

pub fn part_2(input: String) -> String {
  input
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(string.to_graphemes)
  |> list.map(fn(bank) {
    list.map(bank, fn(digit) {
      let assert Ok(digit) = int.parse(digit)
      digit
    })
  })
  // cool, now we have a list of banks, each one a list of batteries
  // let's find the optimal one for each battery
  |> list.map(fn(bank) { best_joltage_n(bank, 12) })
  |> list.fold(0, int.add)
  |> int.to_string
}

pub fn part_2_cached(input: String) -> String {
  let banks = input
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(string.to_graphemes)
  |> list.map(fn(bank) {
    list.map(bank, fn(digit) {
      let assert Ok(digit) = int.parse(digit)
      digit
    })
  })
  // cool, now we have a list of banks, each one a list of batteries
  // let's find the optimal one for each battery
  let #(_cache, results) = list.fold(banks, #(dict.new(), []), fn(acc, bank) {
    let #(cache, results) = acc
    let #(next, cache) = best_joltage_n_cached(bank, 12, cache)
    let results = list.prepend(results, next)
    #(cache, results)
     })

  results
  |> list.fold(0, int.add)
  |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_2_cached(input)
  io.println(result)
}
