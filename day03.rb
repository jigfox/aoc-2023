#!/usr/bin/env ruby

numbers = []

grid = []

first_digit = true
symbols = []

AocSymbol = Struct.new(:x, :y, :symbol)

symbols = []

File.readlines("./input03.txt").map(&:strip).each_with_index do |line, x|
  grid[x] = []
  line.chars.each_with_index do |c, y|
    case c
    when "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
      if first_digit
        first_digit = false
        numbers.push c
      else
        numbers[-1] += c
      end
      grid[x][y] = numbers.size - 1
    when "."
      grid[x][y] = nil
      first_digit = true
    else
      grid[x][y] = c
      first_digit = true
      symbols.push AocSymbol.new x, y, c
    end
  end
end

grid.map(&:inspect)

puts symbols.map { |s|
  nw = grid[s.x - 1][s.y - 1]
  n = grid[s.x][s.y - 1]
  ne = grid[s.x + 1][s.y - 1]
  e = grid[s.x + 1][s.y]
  se = grid[s.x + 1][s.y + 1]
  so = grid[s.x][s.y + 1]
  sw = grid[s.x - 1][s.y + 1]
  w = grid[s.x - 1][s.y]
  [nw, n, ne, e, se, so, sw, w].select { |i| i.is_a? Integer }
}.flatten.uniq.sort.map { |i| numbers[i].to_i }.sum

puts symbols.select { |s| s.symbol == "*" }.map { |s|
  nw = grid[s.x - 1][s.y - 1]
  n = grid[s.x][s.y - 1]
  ne = grid[s.x + 1][s.y - 1]
  e = grid[s.x + 1][s.y]
  se = grid[s.x + 1][s.y + 1]
  so = grid[s.x][s.y + 1]
  sw = grid[s.x - 1][s.y + 1]
  w = grid[s.x - 1][s.y]
  ret = [nw, n, ne, e, se, so, sw, w].select { |i| i.is_a? Integer }.uniq
  (ret.size == 2) ? ret.map { |i| numbers[i].to_i }.inject(:*) : nil
}.compact.inject(:+)
