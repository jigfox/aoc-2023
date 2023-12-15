#!/usr/bin/env ruby

def hash(str)
  str.each_byte.inject(0) { |h, n| ((h + n) * 17) % 256 }
end

p File.readlines("./input15.txt").first.chomp.split(",").map { |input|
  hash input
}.sum

p File.readlines("./input15.txt").first.chomp.split(",").each_with_object(Array.new(256)) { |input, boxes|
  match = input.match(/^(\w+)(.)(\d*)$/)
  h = hash(match[1])
  boxes[h] ||= {}
  if match[2] == "="
    boxes[h][match[1]] = match[3].to_i
  else
    boxes[h].delete match[1]
  end
}.each_with_index.map { |h, i| (h || {}).each_with_index.map { |(k, v), j| (i + 1) * (j + 1) * v } }.flatten.sum
