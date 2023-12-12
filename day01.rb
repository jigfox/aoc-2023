#!/usr/bin/env ruby

puts File.readlines("./input01.txt").map { |line|
  digits = line.chars.filter{ |c| c.match /\d/ }
  (digits.first + digits.last).to_i
}.sum

puts File.readlines("./input01.txt").map { |line|
  a = line.dup
  line.strip!
  # twoneight = 218
  # twone => 21
  # oneight => 18
  # threeight => 38
  # sevenineight => 798
  # sevenine => 79
  # nineight => 98
  line.gsub!(/(one|two|three|four|five|six|seven|eight|nine)/) { |str| 
    case str
    when "one"
      "o1e"
    when "two"
      "t2o"
    when "three"
      "t3ree"
    when "four"
      "f4ur"
    when "five"
      "f5ve"
    when "six"
      "s6x"
    when "seven"
      "se7en"
    when "eight"
      "e8ght"
    when "nine"
      "n9ne"
    end.to_s
  }
  line.gsub!(/(one|two|three|four|five|six|seven|eight|nine)/) { |str| 
    case str
    when "one"
      "o1e"
    when "two"
      "t2o"
    when "three"
      "t3ree"
    when "four"
      "f4ur"
    when "five"
      "f5ve"
    when "six"
      "s6x"
    when "seven"
      "se7en"
    when "eight"
      "e8ght"
    when "nine"
      "n9ne"
    end.to_s
  }
  line.gsub!(/(one|two|three|four|five|six|seven|eight|nine)/) { |str| 
    case str
    when "one"
      "o1e"
    when "two"
      "t2o"
    when "three"
      "t3ree"
    when "four"
      "f4ur"
    when "five"
      "f5ve"
    when "six"
      "s6x"
    when "seven"
      "se7en"
    when "eight"
      "e8ght"
    when "nine"
      "n9ne"
    end.to_s
  }
  digits = line.chars.filter{ |c| c.match /\d/ }
  (digits.first + digits.last).to_i
}.sum
