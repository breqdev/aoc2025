import day4
import gleam/dict
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_grid_test() {
  let check =
    day4.parse_grid(
      "..@
@@@
@.@",
    )

  let expect =
    dict.from_list([
      #(#(0, 0), False),
      #(#(1, 0), False),
      #(#(2, 0), True),
      #(#(0, 1), True),
      #(#(1, 1), True),
      #(#(2, 1), True),
      #(#(0, 2), True),
      #(#(1, 2), False),
      #(#(2, 2), True),
    ])

  assert check == expect
}

pub fn part1_test() {
  assert day4.part_1(
      "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.",
    )
    == "13"
}

pub fn part2_test() {
  assert day4.part_2(
      "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.",
    )
    == "43"
}
