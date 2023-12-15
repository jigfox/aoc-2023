#!/usr/bin/env ruby

def count_diff(a, b)
  a.zip(b).map { |i, j| (i == j) ? 0 : 1 }.sum
end

def find_horizontal_mirror(field, diff_count = 0)
  (1..field.count / 2).each { |t|
    rev = field.reverse
    return t if count_diff(field[0...t].flatten, field[t, t].reverse.flatten) == diff_count
    return field.count - t if count_diff(rev[0...t].flatten, rev[t, t].reverse.flatten) == diff_count
  }
  nil
end

def find_vertical_mirror(field, diff_count = 0)
  find_horizontal_mirror(field.transpose, diff_count)
end

puts File.readlines("./input13.txt").map(&:chomp).each_with_object([]) { |line, fields|
  fields << [] if line.empty? || fields.empty?
  fields.last << line.chars unless line.empty?
}.map { |field|
       # puts field.map(&:join).join("\n")
       [find_horizontal_mirror(field), find_vertical_mirror(field), find_horizontal_mirror(field, 1), find_vertical_mirror(field, 1)]
     }.map { |h1, v1, h2, v2|
       [v1 || h1 * 100, v2 || h2 * 100]
     }.each_with_object([0, 0]) { |nxt, res|
       res[0] += nxt[0]
       res[1] += nxt[1]
     }
