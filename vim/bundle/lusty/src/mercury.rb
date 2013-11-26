# Copyright (C) 2010 Matt Tolton
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# Mercury fuzzy matching algorithm, written by Matt Tolton.
#  based on the Quicksilver and LiquidMetal fuzzy matching algorithms
class Mercury
  public
    def self.score(string, abbrev)
      return self.new(string, abbrev).score()
    end

    def score()
      return @@SCORE_TRAILING if @abbrev.empty?
      return @@SCORE_NO_MATCH if @abbrev.length > @string.length

      raw_score = raw_score(0, 0, 0, false)
      return raw_score / @string.length
    end

    def initialize(string, abbrev)
      @string = string
      @lower_string = string.downcase()
      @abbrev = abbrev.downcase()
      @level = 0
      @branches = 0
    end

  private
    @@SCORE_NO_MATCH = 0.0 # do not change, this is assumed to be 0.0
    @@SCORE_EXACT_MATCH = 1.0
    @@SCORE_MATCH = 0.9
    @@SCORE_TRAILING = 0.7
    @@SCORE_TRAILING_BUT_STARTED = 0.80
    @@SCORE_BUFFER = 0.70
    @@SCORE_BUFFER_BUT_STARTED = 0.80

    @@BRANCH_LIMIT = 100

    #def raw_score(a, b, c, d)
    #  @level += 1
    #  puts "#{' ' * @level}#{a}, #{b}, #{c}, #{d}"
    #  ret = recurse_and_score(a, b, c, d)
    #  puts "#{' ' * @level}#{a}, #{b}, #{c}, #{d} -> #{ret}"
    #  @level -= 1
    #  return ret
    #end

    def raw_score(abbrev_idx, match_idx, score_idx, first_char_matched)
      index = @lower_string.index(@abbrev[abbrev_idx], match_idx)
      return 0.0 if index.nil?

      # TODO Instead of having two scores, should there be a sliding "match"
      # score based on the distance of the matched character to the beginning
      # of the string?
      if abbrev_idx == index
        score = @@SCORE_EXACT_MATCH
      else
        score = @@SCORE_MATCH
      end

      started = (index == 0 or first_char_matched)

      # If matching on a word boundary, score the characters since the last match
      if index > score_idx
        buffer_score = started ? @@SCORE_BUFFER_BUT_STARTED : @@SCORE_BUFFER
        if " \t/._-".include?(@string[index - 1])
          score += @@SCORE_MATCH
          score += buffer_score * ((index - 1) - score_idx)
        elsif @string[index] >= "A"[0] and @string[index] <= "Z"[0]
          score += buffer_score * (index - score_idx)
        end
      end

      if abbrev_idx + 1 == @abbrev.length
        trailing_score = started ? @@SCORE_TRAILING_BUT_STARTED : @@SCORE_TRAILING
        # We just matched the last character in the pattern
        score += trailing_score * (@string.length - (index + 1))
      else
        tail_score = raw_score(abbrev_idx + 1, index + 1, index + 1, started)
        return 0.0 if tail_score == 0.0
        score += tail_score
      end

      if @branches < @@BRANCH_LIMIT
        @branches += 1
        alternate = raw_score(abbrev_idx,
                              index + 1,
                              score_idx,
                              first_char_matched)
        #puts "#{' ' * @level}#{score}, #{alternate}"
        score = [score, alternate].max
      end

      return score
    end
end

