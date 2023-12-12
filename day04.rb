#!/usr/bin/env ruby

multiplicator = []

points = File.readlines("./input04.txt").each_with_index.map { |line, idx|
  multiplicator[idx] ||= 0
  card, numbers = line.split ": "
  winning_numbers, played_numbers = numbers.split(" | ").map{ |n| n.split(" ").map(&:to_i) }
  match_count =(winning_numbers & played_numbers).size
  points = match_count > 0 ? 2 ** (match_count -1) : 0
  if match_count > 0
    multiplicator[idx] += 1
    multiplicator[idx].times do 
      match_count.times { |t|
        multiplicator[idx+t+1] ||= 0
        multiplicator[idx+t+1] += 1
      }
    end
  else
    multiplicator[idx] += 1
  end
  points
}

puts points.inject(:+)
puts multiplicator.slice(0, points.size).inject(:+)
