import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile.{read}

fn parse_ranges(input: String) -> List(#(Int, Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(range) {
    let assert [start, end] = string.split(range, "-")
    let assert Ok(start) = int.parse(start)
    let assert Ok(end) = int.parse(end)

    #(start, end)
  })
}

fn contained_in_range(ingredient: Int, ranges: Set(#(Int, Int))) -> Bool {
  ranges
  |> set.map(fn(range) {
    let #(start, end) = range
    start <= ingredient && ingredient <= end
  })
  |> set.contains(True)
}

pub fn insert_range(
  ranges: Set(#(Int, Int)),
  new: #(Int, Int),
) -> Set(#(Int, Int)) {
  // ranges is a list of (sorted?) non-overlapping ranges
  // new is a range we want to add to these, which may be overlapping

  // new is entirely contained within these ranges
  let enclosed_by =
    ranges
    |> set.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      start <= new_start && new_end <= end
    })

  // new completely encloses these ranges
  let encloses =
    ranges
    |> set.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      new_start <= start && end <= new_end
    })

  // new extends this range on the "start" side
  let extends_back =
    ranges
    |> set.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      new_start <= start && new_end >= start && new_end <= end
    })

  // new extends this range on the "end" side
  let extends_forward =
    ranges
    |> set.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      new_start >= start && new_start <= end && new_end >= end
    })

  case set.is_empty(enclosed_by) {
    True -> {
      // do stuff

      // first, remove everything enclosed by this new range
      let remove_encloses =
        set.filter(ranges, fn(range) { !set.contains(encloses, range) })

      case set.size(extends_back), set.size(extends_forward) {
        0, 0 -> {
          // no further action needed -- we just enclosed a prior range
          // add our new range to the list
          set.insert(remove_encloses, new)
        }
        0, 1 -> {
          // merge our new range with extends_forward
          let assert [extended] = set.to_list(extends_forward)

          let #(start, _end) = extended
          let #(_new_start, new_end) = new

          let merged = #(start, new_end)

          let remove_extended =
            set.filter(remove_encloses, fn(range) { range != extended })

          set.insert(remove_extended, merged)
        }
        1, 0 -> {
          // merge our new range with extends_back
          let assert [extended] = set.to_list(extends_back)

          let #(_start, end) = extended
          let #(new_start, _new_end) = new

          let merged = #(new_start, end)

          let remove_extended =
            set.filter(remove_encloses, fn(range) { range != extended })

          set.insert(remove_extended, merged)
        }
        1, 1 -> {
          // we combine our extends_back and extends_forward

          let assert [first] = set.to_list(extends_forward)
          let assert [second] = set.to_list(extends_back)

          let #(first_start, _first_end) = first
          let #(_second_start, second_end) = second
          let merged = #(first_start, second_end)

          let remove_merged =
            set.filter(remove_encloses, fn(range) {
              range != first && range != second
            })

          set.insert(remove_merged, merged)
        }
        _, _ -> panic
      }
    }
    False -> {
      // the new range is contained within a prior range, no action needed
      ranges
    }
  }
}

pub fn simplify_ranges(unordered: List(#(Int, Int))) -> Set(#(Int, Int)) {
  unordered |> list.fold(set.new(), insert_range)
}

pub fn part_1(input: String) -> String {
  let assert [ranges, ingredients] = string.split(input, "\n\n")

  let ranges = parse_ranges(ranges)
  let ranges = simplify_ranges(ranges)

  let ingredients =
    ingredients |> string.split("\n") |> list.filter_map(int.parse)

  ingredients
  |> list.count(fn(id) { contained_in_range(id, ranges) })
  |> int.to_string
}

pub fn part_2(input: String) -> String {
  let assert [ranges, _ingredients] = string.split(input, "\n\n")
  let ranges = parse_ranges(ranges)
  let ranges = simplify_ranges(ranges)

  ranges
  |> set.to_list
  |> list.map(fn(range) {
    let #(start, end) = range
    end - start + 1
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
