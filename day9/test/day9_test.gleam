import day9
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn part1_test() {
  let result =
    day9.part_1(
      "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3",
    )

  assert result == "50"
}
