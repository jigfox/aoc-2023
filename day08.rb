#!/usr/bin/env ruby

class Node
  attr_accessor :source, :l, :r
  def initialize(source, l, r)
    @source = source
    @l = l
    @r = r
  end
end

nodes = {}
instructions = []

File.readlines("./input08.txt").each do |line|
  case line.chomp
  when /^[LR]+$/
    instructions += line.chomp.chars
  when /^([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)$/
    nodes[$1] = Node.new $1, $2, $3
  end
end

current_node = nodes["AAA"]
counter = 0

while current_node.source != "ZZZ"
  direction = instructions[counter % instructions.count]
  current_node = nodes[(direction == "L") ? current_node.l : current_node.r]
  counter += 1
end
puts counter

starting_nodes = nodes.select { |k, _| k.end_with? "A" }.values

nl = starting_nodes.map { |sn|
  counter2 = 0
  until sn.source.end_with?("Z")
    direction = instructions[counter2 % instructions.count]
    sn = nodes[(direction == "L") ? sn.l : sn.r]
    counter2 += 1
  end
  counter2
}
nl << instructions.count
puts nl.reduce(:lcm)
