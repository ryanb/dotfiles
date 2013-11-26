# Mercury tests, as well the quicksilver and liquidmetal algorithms which we
# sometimes use for comparison

require 'mercury'

# Fuzzy matching algorithm from Quicksilver, the OS X tool
def qs_score(entry, abbrev)
  return 0.9 if abbrev.length == 0
  return 0.0 if abbrev.length > entry.length

  abbrev.length.downto(1) do |i|
    sub_abbrev = abbrev[0...i]
    index = entry.index(sub_abbrev)

    next if index.nil?
    next if index + sub_abbrev.length > entry.length

    next_entry = entry[index+sub_abbrev.length..-1]

    next_abbrev = i >= abbrev.length ? "" : abbrev[i..-1]

    remaining_score = qs_score(next_entry, next_abbrev)

    if remaining_score > 0
      score = entry.length - next_entry.length

      if index != 0
        c = entry[index - 1]
        word_boundaries = " \t/._"
        if word_boundaries.include?(c)
          for j in 0...(index-1)
            c = entry[j]
            score -= word_boundaries.include?(c) ? 1 : 0.15
          end
        else
          score -= index
        end
      end

      score += remaining_score * next_entry.length
      score /= entry.length
      return score
    end
  end
  return 0.0
end

# Port of Ryan McGeary's LiquidMetal fuzzy matching algorithm found at:
#   http://github.com/rmm5t/liquidmetal/tree/master.
class LiquidMetal
  @@SCORE_NO_MATCH = 0.0
  @@SCORE_MATCH = 1.0
  @@SCORE_TRAILING = 0.8
  @@SCORE_TRAILING_BUT_STARTED = 0.90
  @@SCORE_BUFFER = 0.85

  def self.score(string, abbrev)
    return @@SCORE_TRAILING if abbrev.empty?
    return @@SCORE_NO_MATCH if abbrev.length > string.length

    scores = buildScoreArray(string, abbrev)

    sum = scores.inject { |a, b| a + b }

    return sum / scores.length;
  end

  def self.buildScoreArray(string, abbrev)
    scores = Array.new(string.length)
    lower = string.downcase()

    lastIndex = -1
    started = false

    abbrev.downcase().each_byte do |c|
      index = lower.index(c, lastIndex + 1)
      return scores.fill(@@SCORE_NO_MATCH, 0..-1) if index.nil?
      started = true if index == 0

      if index > 0 and " \t/._-".include?(string[index - 1])
        scores[index - 1] = @@SCORE_MATCH
        scores.fill(@@SCORE_BUFFER, (lastIndex + 1)...(index - 1))
      elsif string[index] >= "A"[0] and string[index] <= "Z"[0]
        scores.fill(@@SCORE_BUFFER, (lastIndex + 1)...index)
      else
        scores.fill(@@SCORE_NO_MATCH, (lastIndex + 1)...index)
      end

      scores[index] = @@SCORE_MATCH
      lastIndex = index
    end

    trailing_score = started ? @@SCORE_TRAILING_BUT_STARTED : @@SCORE_TRAILING
    scores.fill(trailing_score, lastIndex + 1)
    return scores
  end
end

def print_score(entry, abbrev)
  old_score = LiquidMetal.score(entry, abbrev)
  new_score = Mercury.score(entry, abbrev)

  puts "%-25s %-10s %.4f %.4f" % [entry, abbrev, old_score, new_score]
end

def test(high_entry, low_entry, abbrev)
  high = Mercury.score(high_entry, abbrev)
  low = Mercury.score(low_entry, abbrev)
  puts "%-8s %-10s %-25s %.4f %-25s %.4f" % [high > low ? "PASS" : "FAIL", abbrev,
    high_entry, high, low_entry, low]
end

print_score("phone numbers.txt", "phnb")
print_score("phone numbers.txt", "pht")
print_score("poohead.txt", "pht")
print_score("poohead.txt", "poo")
print_score("poohead.txt", "pood")
print_score("foo.lua", "lua")
print_score("lua-expression.h", "lua")
print_score("query-dispatcher.h", "qudisp")
print_score("query-dispatcher.cc", "qudisp")
print_score("query-dispatcher.h", "qudisph")
print_score("query-dispatcher.cc", "qudisph")
print_score("query-dispatczer.h", "qudisph")
print_score("query-dispatczer.h", "qudisp")
print_score("aaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaa")
print_score("query-executor.h", "exec")
print_score("query-executor.cc", "exec")
print_score("tablet-executor-node.h", "ten")
print_score("materialize-executor-node.h", "ten")

test("protocoltype.go", "serverstatus.proto", "proto")
test("protocoltype.go", "test.proto", "proto")
test("protocoltype.go", "test.proto", "pr")
test("protocoltype.go", "test.proto", "p")
test("protocoltype.go", "test.proto", "poto")
test("query-dispatcher.h", "query-dispatcher.cc", "qudisph")
test("query-plan.h", "query-dispatcher.h", "qup")
test("phone numbers.txt", "poohead.txt", "pht")
test("tokyo.txt", "abcde.txt", "t")
test("tablet-executor-node.h", "materialize-executor-node.h", "ten")
test("tent.txt", "tablet-executor-node.h", "ten")
test("tent.txt", "tablet-executor-node.h", "te")
test("ad", "m-a", "a")
test("a", "b", "A")
