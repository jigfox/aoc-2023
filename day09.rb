#!/usr/bin/env ruby

p File.readlines("./input09.txt").map { |line|
  hist = [line.split(" ").map(&:to_i)]
  until hist.last.all? { |v| v == 0 }
    hist << hist.last.each_cons(2).map { |a, b| b - a }
  end
  hist.reverse.each_cons(2).each_with_index.map { |(a, b), i|
    b << b.last if i == 0
    b << a.last + b.last if i > 0
    b
  }.last.last
}.sum

p File.readlines("./input09.txt").map { |line|
  hist = [line.split(" ").map(&:to_i)]
  until hist.last.all? { |v| v == 0 }
    hist << hist.last.each_cons(2).map { |a, b| b - a }
  end
  hist.reverse.each_cons(2).each_with_index.map { |(a, b), i|
    b.unshift(b.first) if i == 0
    b.unshift(b.first - a.first) if i > 0
    b
  }.last.first
}.sum
