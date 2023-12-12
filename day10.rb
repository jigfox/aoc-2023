#!/usr/bin/env ruby

starting_point = nil

Point = Struct.new(:x, :y)
cs = []

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

map = File.readlines("./input10.txt").map(&:chomp).each_with_index.map { |line, y|
  cs[y] = []
  line.chars.each_with_index.map { |c, x|
    case c
    when "|"
      cs[y] << "│"
      [
        Point.new(x, y + 1),
        Point.new(x, y - 1)
      ]
    when "-"
      cs[y] << "─"
      [
        Point.new(x + 1, y),
        Point.new(x - 1, y)
      ]
    when "L"
      cs[y] << "└"
      [
        Point.new(x, y - 1),
        Point.new(x + 1, y)
      ]
    when "J"
      cs[y] << "┘"
      [
        Point.new(x, y - 1),
        Point.new(x - 1, y)
      ]
    when "7"
      cs[y] << "┐"
      [
        Point.new(x, y + 1),
        Point.new(x - 1, y)
      ]
    when "F"
      cs[y] << "┌"
      [
        Point.new(x + 1, y),
        Point.new(x, y + 1)
      ]
    when "S"
      cs[y] << "┼".green
      starting_point = Point.new(x, y)
      [
        Point.new(x + 1, y),
        Point.new(x - 1, y),
        Point.new(x, y + 1),
        Point.new(x, y - 1)
      ]
    else
      cs[y] << " "
      []
    end
  }
}

puts cs.map(&:join)

counter = 0
visited = Set.new

def find_next(point, map, visited)
  visited.add point
  possible_points = map[point.y][point.x]
  case possible_points.count
  when 4
    possible_points.reverse.find { |p| map[p.y][p.x].include?(point) }
  when 2
    possible_points.find { |p| !visited.include? p }
  end
end

current_point = starting_point
outer_border = "left"

puts "#{current_point}: #{cs[current_point.y][current_point.x]}"
while current_point = find_next(current_point, map, visited)
  cs[current_point.y][current_point.x]
  counter += 1
end
print "\e[H\e[2J"
cs.each_with_index { |l, y|
  print "%03d: " % y
  l.each_with_index { |c, x| print visited.include?(Point.new(x, y)) ? c.red : c }
  print "\n"
}

puts (counter + 1) / 2

outer = Set.new
def has_outer_neighbor?(p, outer)
  outer.include?(Point.new(p.x + 1, p.y)) ||
    outer.include?(Point.new(p.x - 1, p.y)) ||
    outer.include?(Point.new(p.x, p.y + 1)) ||
    outer.include?(Point.new(p.x, p.y - 1))
end

cs.each_with_index { |l, y|
  l.each_with_index { |c, x|
    p = Point.new(x, y)
    outer.add(p) if (x == 0 || y == 0 || has_outer_neighbor?(p, outer)) && !visited.include?(p)
  }
  l.each_with_index.reverse_each { |c, x|
    p = Point.new(x, y)
    outer.add(p) if (x == 0 || y == 0 || has_outer_neighbor?(p, outer)) && !visited.include?(p)
  }
}
cs.each_with_index.reverse_each { |l, y|
  l.each_with_index { |c, x|
    p = Point.new(x, y)
    outer.add(p) if (x == 0 || y == 0 || has_outer_neighbor?(p, outer)) && !visited.include?(p)
  }
  l.each_with_index.reverse_each { |c, x|
    p = Point.new(x, y)
    outer.add(p) if (x == 0 || y == 0 || has_outer_neighbor?(p, outer)) && !visited.include?(p)
  }
}
counter = 0
cs.each_with_index { |l, y|
  print "%03d: " % y
  l.each_with_index { |c, x|
    p = Point.new(x, y)
    if visited.include? p
      print c.red
    elsif outer.include? p
      print c.light_blue
    else
      counter += 1

      print c.pink
    end
  }
  print "\n"
}
puts counter
