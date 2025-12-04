import day2
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn day2_test() {
  let result =
    day2.part_1(
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124",
    )

  assert result == "1227775554"
}

pub fn part2_test() {
  let result =
    day2.part_2(
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124",
    )

  assert result == "4174379265"
}

pub fn part2_mult_invalid_test() {
  let result = day2.part_2("9-33")

  assert result == "66"
}

pub fn part2_zero_test() {
  let result = day2.part_2("1698522-1698528")
  assert result == "0"
}
