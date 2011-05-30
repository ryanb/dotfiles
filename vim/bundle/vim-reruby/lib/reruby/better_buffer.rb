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

    def grep_backwards_from(line, regexp)
      until self[line] =~ regexp
        line -= 1
      end
      line
    end

    def measure_indent(s)
      s.match(/^\s*/).to_s.length
    end

    def indent(depth, lines)
      case lines
        when Array
          indent_multiple_lines(depth, lines)
        else
          indent_one_line(depth, lines)
      end
    end

    def unindent(depth, lines)
      case lines
        when Array
          unindent_multiple_lines(depth, lines)
        else
          unindent_one_line(depth, lines)
      end
    end

    def reindent(new_depth, lines)
      original_depth = measure_indent(lines.first)
      indent(new_depth, unindent(original_depth, lines))
    end

  private

    def indent_one_line(depth, line)
      indent = " "*depth
      line == "" ? "" : "#{indent}#{line}"
    end

    def indent_multiple_lines(depth, lines)
      lines.map {|line| indent_one_line(depth, line) }
    end
    
    def unindent_one_line(depth, line)
      indent = " "*depth
      line.sub(/^#{indent}/, "")
    end

    def unindent_multiple_lines(depth, lines)
      lines.map {|line| unindent_one_line(depth, line) }
    end
          
  end
end
