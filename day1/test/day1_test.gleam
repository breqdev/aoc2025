import day1
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn day1_test() {
  let result =
    day1.part_1(
      "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
",
    )

  assert result == "3"
}

pub fn day2_test() {
  let result =
    day1.part_2(
      "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
",
    )

  assert result == "6"
}

pub fn day2_many_repetition_test() {
  let result = day1.part_2("R1000")

  assert result == "10"
}

pub fn day2_many_repetition_2_test() {
  let result = day1.part_2("L1000")

  assert result == "10"
}

pub fn day2_left_from_zero_test() {
  assert day1.part_2(
      "L50
L9",
    )
    == "1"

  assert day1.part_2(
      "L50
L99",
    )
    == "1"

  assert day1.part_2(
      "L50
L100",
    )
    == "2"

  assert day1.part_2(
      "L50
L101",
    )
    == "2"

  assert day1.part_2(
      "L50
L199",
    )
    == "2"

  assert day1.part_2(
      "L50
L200",
    )
    == "3"

  assert day1.part_2(
      "L50
L201",
    )
    == "3"
}

pub fn day2_right_from_zero_test() {
  assert day1.part_2(
      "L50
R9",
    )
    == "1"

  assert day1.part_2(
      "L50
R99",
    )
    == "1"

  assert day1.part_2(
      "L50
R100",
    )
    == "2"

  assert day1.part_2(
      "L50
R101",
    )
    == "2"

  assert day1.part_2(
      "L50
R199",
    )
    == "2"

  assert day1.part_2(
      "L50
R200",
    )
    == "3"

  assert day1.part_2(
      "L50
R201",
    )
    == "3"
}

pub fn day2_left_from_nonzero_test() {
  assert day1.part_2("L0") == "0"
  assert day1.part_2("L49") == "0"
  assert day1.part_2("L50") == "1"
  assert day1.part_2("L51") == "1"
  assert day1.part_2("L99") == "1"
  assert day1.part_2("L100") == "1"
  assert day1.part_2("L101") == "1"
  assert day1.part_2("L149") == "1"
  assert day1.part_2("L150") == "2"
  assert day1.part_2("L151") == "2"
}

pub fn day2_right_from_nonzero_test() {
  assert day1.part_2("R0") == "0"
  assert day1.part_2("R49") == "0"
  assert day1.part_2("R50") == "1"
  assert day1.part_2("R51") == "1"
  assert day1.part_2("R99") == "1"
  assert day1.part_2("R100") == "1"
  assert day1.part_2("R101") == "1"
  assert day1.part_2("R149") == "1"
  assert day1.part_2("R150") == "2"
  assert day1.part_2("R151") == "2"
}
