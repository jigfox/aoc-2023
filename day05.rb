#!/usr/bin/env ruby

class Range
  def intersection(other)
    return nil if self.end < other.begin || other.end < self.begin
    [self.begin, other.begin].max..[self.end, other.end].min
  end

  def plus(n)
    self.begin + n..self.end + n
  end

  def minus(other)
    if other.is_a?(Array)
      return [self] if other.empty?
      return other.map(&method(:minus)).reduce { |a, b| a.product(b).filter_map { |p, q| p & q } }
    end
    return [self] if other.nil? || self.begin > other.end || self.end < other.begin
    return [] if self.begin >= other.begin && self.end <= other.begin
    return [[self.begin, other.end].max + 1..self.end] if self.begin >= other.begin && self.begin <= other.end
    return [self.begin..[self.end, other.begin].min - 1] if self.end <= other.end && self.end >= other.begin
    [self.begin..[self.end, other.begin].min - 1, [self.begin, other.end].max + 1..self.end]
  end
  alias_method :&, :intersection
  alias_method :+, :plus
  alias_method :-, :minus
end

class SeedNumber
  attr_accessor :destination_numbers
  def initialize(number)
    @destination_numbers = {}
    @destination_numbers["seed"] = number
  end
end

seeds = []
seeds2 = []
mappings_data = []

current_source = ""
current_destination = ""

File.readlines("./input05.txt").each do |line|
  case line.strip
  when /^seeds:/
    numbers = line.split(": ").last.split(" ").map(&:to_i)
    seeds = numbers.map { |number| SeedNumber.new(number) }
    seeds2 = numbers.each_slice(2).map { |start, step| (start..start + step - 1) }
  when /^(\w+)-to-(\w+) map:/
    mappings_data << []
    current_source = $1
    current_destination = $2
  when /^(\d+) (\d+) (\d+)$/
    destination_range_start = $1.to_i
    source_range_start = $2.to_i
    range_length = $3.to_i
    mappings_data[-1] << [destination_range_start, source_range_start, range_length]
    seeds.each do |seed|
      seed.destination_numbers[current_destination] = if seed.destination_numbers[current_source] >= source_range_start && seed.destination_numbers[current_source] < source_range_start + range_length
        seed.destination_numbers[current_source] + destination_range_start - source_range_start
      elsif !seed.destination_numbers[current_destination]
        seed.destination_numbers[current_source]
      else
        seed.destination_numbers[current_destination]
      end
    end
  end
end

puts seeds.min { |a, b| a.destination_numbers["location"] <=> b.destination_numbers["location"] }.destination_numbers["location"]

puts mappings_data.map { |md|
  Hash.new { |hash, key_range|
    rs = []
    mappable = md.filter_map { |dst, src, step|
      r = key_range & (src..src + step - 1)
      ((rs << r) and r + (dst - src)) if r
    }
    non_mappable = key_range - rs
    mappable + non_mappable
  }
}.reduce(seeds2) { |acc, reducer| acc.map(&reducer.method(:[])).flatten }.map { |range| range.min }.compact.min
