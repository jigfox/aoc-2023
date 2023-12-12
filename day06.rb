#!/usr/bin/env ruby

races = [
  {time: 40, distance: 215},
  {time: 92, distance: 1064},
  {time: 97, distance: 1505},
  {time: 90, distance: 1100}
]

puts races.map { |race|
  1.upto(race[:time] - 1).map { |ms| ms * (race[:time] - ms) }.count { |distance| distance > race[:distance] }
}.inject(:*)

time = 40929790
distance = 215106415051100

puts 1.upto(time - 1).map { |ms| ms * (time - ms) }.count { |dist| dist > distance }
