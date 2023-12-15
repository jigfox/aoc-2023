#!/usr/bin/env ruby

Record = Struct.new(:conditions, :groups) do
  def missing
    groups.sum - conditions.count { |c| c }
  end

  def options
    conditions.count { |c| c.nil? }
  end
end

records = File.readlines("./input12.txt").map(&:chomp).map { |l| l.split(" ") }.map { |cs, gs| Record.new(cs.chars.map { |c| (c == "?") ? nil : c == "#" }, gs.split(",").map(&:to_i)) }

p records.map { |r| r.missing == r.options }
