#!/usr/bin/env ruby

class Game
  attr_reader :id, :sets
  def initialize(line)
    game, input = line.split(": ")
    @id = game.split(" ").last.to_i
    @sets = input.split("; ").map do |set|
      combination = set.split(", ").map do |cubes|
        count, color = cubes.split(" ")
        [color, count.to_i]
      end.to_h
    end
  end

  def power
    @sets.inject{ |a,b|
      {
        "red" => [(a["red"] || 0), (b["red"] || 0)].max,
        "green" => [(a["green"] || 0), (b["green"] || 0)].max,
        "blue" => [(a["blue"] || 0), (b["blue"] || 0)].max,
      }
    }.values.inject(:*)
  end
end

games = []

File.readlines("./input02.txt").each do |line|
  games.push Game.new line
end

input = { "red" => 12, "green" => 13, "blue" => 14 }

puts games.reject { |game|
  game.sets.any? { |set|
    (set["red"] || 0) > input["red"] or (set["green"] || 0) > input["green"] or (set["blue"] || 0) > input["blue"]
  }
}.map { |game| game.id  }.sum

puts games.map{ |game|
  game.power
}.sum
