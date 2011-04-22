module Reruby
  class BetterBuffer

    def initialize(buffer)
      @buffer = buffer
    end

    def [](line_or_range)
      case line_or_range
        when Range
          line_or_range.map {|line| @buffer[line] }
        else
          @buffer[line_or_range]
      end
    end

    def []=(line_or_range, lines)
      case line_or_range
        when Range
          delete(line_or_range)
          append(line_or_range.first - 1, lines)
        else
          @buffer[line_or_range] = lines
      end
    end

    def delete(line_or_range)
      case line_or_range
        when Range
          line_or_range.count.times { @buffer.delete(line_or_range.first) }
        else
          @buffer.delete(line_or_range)
      end
    end

    def append(after, lines)
      case lines
        when Array
          lines.each_with_index do |line, index|
            @buffer.append(after + index, line)
          end
        else
          @buffer.append(after, lines)
      end
    end
          
  end
end
