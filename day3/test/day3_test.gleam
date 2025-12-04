import day3
import gleam/int
import gleam/list
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn part1_test() -> Nil {
  let result =
    day3.part_1(
      "987654321111111
811111111111119
234234234234278
818181911112111",
    )

  assert result == "357"
}

pub fn best_joltage_n_test() -> Nil {
  let split = fn(str: String) {
    str
    |> string.to_graphemes
    |> list.map(fn(digit) {
      let assert Ok(digit) = int.parse(digit)
      digit
    })
  }

  assert day3.best_joltage_n(split("987654321111111"), 2) == 98
  assert day3.best_joltage_n(split("987654321111111"), 12) == 987_654_321_111
}

pub fn part2_test() -> Nil {
  let result =
    day3.part_2_cached(
      "987654321111111
811111111111119
234234234234278
818181911112111",
    )

  assert result == "3121910778619"
}
