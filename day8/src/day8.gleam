import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile.{read}

type Point =
  #(Int, Int, Int)

type Pair =
  #(Point, Point)

fn distance(pair: Pair) -> Float {
  let #(first, second) = pair

  let #(x1, y1, z1) = first
  let #(x2, y2, z2) = second

  let assert Ok(xpow) = int.power(x1 - x2, 2.0)
  let assert Ok(ypow) = int.power(y1 - y2, 2.0)
  let assert Ok(zpow) = int.power(z1 - z2, 2.0)
  let assert Ok(result) = float.square_root(xpow +. ypow +. zpow)

  result
}

fn reverse(pair: Pair) -> Pair {
  let #(first, second) = pair
  #(second, first)
}

fn closest_pairs(boxes: List(Point)) -> List(Pair) {
  boxes
    |> list.combination_pairs
    |> list.sort(fn(pair1, pair2) {
      float.compare(distance(pair1), distance(pair2))
    })
}

fn dfs(connections: List(Pair), start: Point, visited: Set(Point)) -> Set(Point) {
  let visited = set.insert(visited, start)

  let neighbors =
    connections
    |> list.filter_map(fn(pair) {
      let #(first, second) = pair
      case first == start, second == start {
        True, False -> Ok(second)
        False, True -> Ok(first)
        False, False -> Error(Nil)
        True, True -> panic
      }
    })

  neighbors
  |> list.fold(visited, fn(visited, neighbor) {
    case set.contains(visited, neighbor) {
      False -> dfs(connections, neighbor, visited)
      True -> visited
    }
  })
}

fn find_components(
  boxes: List(Point),
  connections: List(Pair),
  groups: Set(Set(Point)),
) {
  let next =
    boxes
    |> list.filter(fn(point) {
      !{
        groups
        |> set.to_list
        |> list.any(fn(group) { set.contains(group, point) })
      }
    })

  case next {
    [first, ..] -> {
      let new_group = dfs(connections, first, set.new())

      let new_groups = set.insert(groups, new_group)

      find_components(boxes, connections, new_groups)
    }
    [] -> groups
  }
}

pub fn part_1(input: String, n: Int) -> String {
  echo "parsing boxes"

  let boxes =
    input
    |> string.split("\n")
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.map(fn(line) { string.split(line, ",") })
    |> list.map(fn(line) {
      line
      |> list.map(fn(coordinate) {
        let assert Ok(result) = int.parse(coordinate)
        result
      })
    })
    |> list.map(fn(line) {
      let assert [x, y, z] = line
      #(x, y, z)
    })

  echo "finding connections"

  let connections = closest_pairs(boxes)
  let connections = list.take(connections, n)

  echo "searching for components"

  let components = find_components(boxes, connections, set.new())

  echo "finding largest"

  let largest =
    components
    |> set.to_list
    |> list.map(set.size)
    |> list.sort(int.compare)
    |> list.reverse
    |> list.take(3)

  echo "done"

  largest |> list.fold(1, int.multiply) |> int.to_string
}

pub fn main() -> Nil {
  let input = read(from: "input.txt")
  let assert Ok(input) = input
  let result = part_1(input, 1000)
  io.println(result)
}
