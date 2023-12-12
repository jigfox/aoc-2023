#!/usr/bin/env ruby
Star = Struct.new :x, :y
stars = []
galaxy = File.readlines("./input11.txt").map(&:chomp).each_with_index.map { |line, y| line.chars.each_with_index.map { |s, x| s == "#" } }
empty_rows = galaxy.each_with_index.select { |line, _| line.all? { |s| !s } }.map { |_, idx| idx }
empty_cols = galaxy.transpose.each_with_index.select { |line, _| line.all? { |s| !s } }.map { |_, idx| idx }
galaxy.each_with_index { |l, y| l.each_with_index { |s, x| stars << Star.new(x, y) if s } }
p stars.combination(2).map { |a, b| (a.x - b.x).abs + (a.y - b.y).abs + (([a.x, b.x].min..[a.x, b.x].max).to_a & empty_cols).count + (([a.y, b.y].min..[a.y, b.y].max).to_a & empty_rows).count }.sum
expansion = 1_000_000 - 1
p stars.combination(2).map { |a, b| (a.x - b.x).abs + (a.y - b.y).abs + (([a.x, b.x].min..[a.x, b.x].max).to_a & empty_cols).count * expansion + (([a.y, b.y].min..[a.y, b.y].max).to_a & empty_rows).count * expansion }.sum
