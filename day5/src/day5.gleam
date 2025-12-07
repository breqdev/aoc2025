import gleam/int
import gleam/io
import gleam/list
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

fn contained_in_range(ingredient: Int, ranges: List(#(Int, Int))) -> Bool {
  ranges
  |> list.any(fn(range) {
    let #(start, end) = range
    start <= ingredient && ingredient <= end
  })
}

pub fn insert_range(
  ranges: List(#(Int, Int)),
  new: #(Int, Int),
) -> List(#(Int, Int)) {
  // ranges is a list of (sorted?) non-overlapping ranges
  // new is a range we want to add to these, which may be overlapping

  // new is entirely contained within these ranges
  let enclosed_by =
    ranges
    |> list.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      start <= new_start && new_end <= end
    })

  // new completely encloses these ranges
  let encloses =
    ranges
    |> list.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      new_start <= start && end <= new_end
    })

  // new extends this range on the "start" side
  let extends_back =
    ranges
    |> list.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      new_start <= start && new_end >= start && new_end <= end
    })

  // new extends this range on the "end" side
  let extends_forward =
    ranges
    |> list.filter(fn(range) {
      let #(start, end) = range
      let #(new_start, new_end) = new

      new_start >= start && new_start <= end && new_end >= end
    })

  // echo "the list"
  // echo new
  // echo "extends the ranges"
  // echo ranges
  // echo "as follows:"
  // echo "enclosed by"
  // echo enclosed_by
  // echo "encloses"
  // echo encloses
  // echo "extends_back"
  // echo extends_back
  // echo "extends_forward"
  // echo extends_forward

  case enclosed_by {
    [] -> {
      // do stuff

      // first, remove everything enclosed by this new range
      let remove_encloses =
        list.filter(ranges, fn(range) { !list.contains(encloses, range) })

      case list.length(extends_back), list.length(extends_forward) {
        0, 0 -> {
          // no further action needed -- we just enclosed a prior range
          // add our new range to the list
          list.prepend(remove_encloses, new)
        }
        0, 1 -> {
          // merge our new range with extends_forward
          let assert Ok(extended) = list.first(extends_forward)

          let #(start, _end) = extended
          let #(_new_start, new_end) = new

          let merged = #(start, new_end)

          let remove_extended =
            list.filter(remove_encloses, fn(range) { range != extended })

          list.prepend(remove_extended, merged)
        }
        1, 0 -> {
          // merge our new range with extends_back
          let assert Ok(extended) = list.first(extends_back)

          let #(_start, end) = extended
          let #(new_start, _new_end) = new

          let merged = #(new_start, end)

          let remove_extended =
            list.filter(remove_encloses, fn(range) { range != extended })

          list.prepend(remove_extended, merged)
        }
        1, 1 -> {
          // we combine our extends_back and extends_forward

          let assert Ok(first) = list.first(extends_forward)
          let assert Ok(second) = list.first(extends_back)

          let #(first_start, _first_end) = first
          let #(_second_start, second_end) = second
          let merged = #(first_start, second_end)

          let remove_merged =
            list.filter(remove_encloses, fn(range) {
              range != first && range != second
            })

          list.prepend(remove_merged, merged)
        }
        _, _ -> panic
      }
    }
    _ -> {
      // the new range is contained within a prior range, no action needed
      ranges
    }
  }
}

pub fn simplify_ranges(unordered: List(#(Int, Int))) -> List(#(Int, Int)) {
  unordered |> list.fold(list.new(), insert_range)
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
