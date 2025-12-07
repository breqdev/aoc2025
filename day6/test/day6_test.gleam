import day6
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn part1_test() {
  let result =
    day6.part_1(
      "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  ",
    )

  assert result == "4277556"
}
