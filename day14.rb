#!/usr/bin/env ruby

def calc_load(grid)
  grid.transpose.map { |r| [false] + r + [false] }.map { |c|
    c.reverse.each_with_index.select { |p, _| p == true }.map { |_, i| i }.sum
  }.sum
end

grid = File.readlines("./input14.txt").map(&:chomp).map { |line|
  line.chars.map { |c|
    case c
    when "O"
      true
    when "#"
      false
    when "."
      nil
    end
  }
}

calc_load grid

def tilt(grid, direction)
  grid = case direction
  when :north
    grid.transpose.map { |r| [false] + r + [false] }
  when :west
    grid.map { |r|
      [false] + r + [false]
    }
  when :south
    grid.reverse.transpose.map { |r| [false] + r + [false] }
  when :east
    grid.map { |r|
      [false] + r.reverse + [false]
    }
  end
  grid = grid.map { |col|
    squares = col.each_with_index.select { |p, _| p == false }.map { |_, i| i }
    squares.each_cons(2).map { |a, b| (a + 1..b - 1) }.map { |r|
      v = col[r]
      count = v.count { |p| p == true }
      Array.new(count, true) + Array.new(v.count - count, nil) + [false]
    }.flatten[..-2]
  }
  case direction
  when :north
    grid.transpose
  when :west
    grid
  when :south
    grid.transpose.reverse
  when :east
    grid.map(&:reverse)
  end
end

def cycle(grid)
  [:north, :west, :south, :east].inject(grid) { |g, d|
    tilt(g, d)
  }
end

p calc_load tilt grid, :north

weights = []
grid2 = grid.dup

loop do
  grid2 = cycle grid2
  weights << weight = calc_load(grid2)
  idx = weights[..-2].rindex(weight)
  length = weights.count - 1
  next unless idx && weights[idx..-2] == weights[2 * idx - length...idx]
  length -= idx
  p weights[(idx + (1_000_000_000 + ~idx) % length)]
  break
end
