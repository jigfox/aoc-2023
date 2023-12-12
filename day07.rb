#!/usr/bin/env ruby

class Hand
  include Comparable

  attr_accessor :cards, :bid

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
  end

  def <=>(other)
    if other.rank == rank
      -1 * cardranks.each_with_index.map { |cr, idx| cr <=> other.cardranks[idx] }.find { |v| v != 0 } || 0
    else
      other.rank <=> rank
    end
  end

  def rank
    @rank ||= if uniq_count.size == 1
      # five of a kind
      7
    elsif uniq_count.size == 2 && uniq_count.any? { |k, v| v == 4 }
      # four of a kind
      6
    elsif uniq_count.size == 2
      # puts "FullHouse: #{cards.join}"
      # full house
      5
    elsif uniq_count.size == 3 && uniq_count.any? { |k, v| v == 3 }
      # three of a kind
      4
    elsif uniq_count.size == 3
      # two pairs
      3
    elsif uniq_count.size == 4
      # one pair
      2
    else
      # high card
      1
    end
  end

  def cardranks
    @cardranks ||= @cards.map { |card|
      "AKQJT98765432".chars.reverse.find_index card
    }
  end

  def uniq_count
    @uniq_count ||= @cards.group_by { |c| c }.map { |k, v| [k, v.length] }.to_h
  end
end

class Hand2
  include Comparable

  attr_accessor :cards, :bid

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
  end

  def <=>(other)
    puts [cards.join, uniq_count].join(", ") if [rank, other.rank].any? { |r| r.nil? }
    if other.rank == rank
      -1 * cardranks.each_with_index.map { |cr, idx| cr <=> other.cardranks[idx] }.find { |v| v != 0 } || 0
    else
      other.rank <=> rank
    end
  end

  def rank
    @rank ||= if uniq_count.size == 1
      # five of a kind
      7
    elsif uniq_count.size == 2 && uniq_count.any? { |k, v| v == 4 }
      # four of a kind
      (joker_count > 0) ? 7 : 6
    elsif uniq_count.size == 2
      # full house
      (joker_count > 0) ? 7 : 5
    elsif uniq_count.size == 3 && uniq_count.any? { |k, v| v == 3 }
      case joker_count
      when 0
        4 # three of a kind
      when 1, 3
        6 # four of a kind
      when 2
        7 # five of kind
      end
    elsif uniq_count.size == 3
      case joker_count
      when 0
        3 # two pairs
      when 1
        5 # full house
      when 2
        6 # four of a kind
      end
    elsif uniq_count.size == 4
      case joker_count
      when 0
        2 # one pair
      when 1, 2
        4 # three of kind
      end
    else
      # high card
      1 + joker_count
    end
  end

  def cardranks
    @cardranks ||= @cards.map { |card|
      "AKQT98765432J".chars.reverse.find_index card
    }
  end

  def uniq_count
    @uniq_count ||= @cards.group_by { |c| c }.map { |k, v| [k, v.length] }.to_h
  end

  def joker_count
    @joker_count ||= @cards.count { |c| c == "J" }
  end
end

hands2 = []

hands = File.readlines("./input07.txt").map { |line|
  cards, bid = line.strip.split(" ")
  hands2 << Hand2.new(cards.chars, bid.to_i)
  Hand.new(cards.chars, bid.to_i)
}

puts hands.sort.reverse.each_with_index.map { |hand, idx|
  # puts [hand.cards.join, hand.bid, hand.bid * (idx + 1)].join(": ")
  hand.bid * (idx + 1)
}.inject(:+)

puts hands2.sort.reverse.each_with_index.map { |hand, idx|
  puts [hand.cards.join, hand.cardranks.map(&:to_s).join("+"), hand.rank, hand.bid, hand.bid * (idx + 1)].join(": ")
  hand.bid * (idx + 1)
}.inject(:+)
