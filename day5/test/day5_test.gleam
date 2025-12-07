import day5
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
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
