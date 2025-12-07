import day5
import gleam/int
import gleam/list
import gleam/set
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn simplify_ranges_test() {
  let example_ranges = [
    #(3, 5),
    #(10, 14),
    #(16, 20),
    #(12, 18),
  ]

  let expected_merged = [#(3, 5), #(10, 20)]

  let result =
    day5.simplify_ranges(example_ranges)
    |> set.to_list
    |> list.sort(fn(a, b) {
      let #(a, _) = a
      let #(b, _) = b
      int.compare(a, b)
    })

  assert result == expected_merged
}

pub fn part1_test() {
  let result =
    day5.part_1(
      "3-5
10-14
16-20
12-18

1
5
8
11
17
32",
    )

  assert result == "3"
}

pub fn part2_test() {
  let result =
    day5.part_2(
      "3-5
10-14
16-20
12-18

1
5
8
11
17
32",
    )

  assert result == "14"
}
