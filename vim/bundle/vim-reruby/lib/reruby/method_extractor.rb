require 'reruby/better_buffer'

module Reruby
  class MethodExtractor

    def initialize(buffer)
      @buffer = BetterBuffer.new(buffer)
    end

    def extract_method(line_range, method_name) 
      extracted_lines = @buffer[line_range]

      # Replace the extracted lines with a call to the new method.
      @buffer[line_range] = @buffer.indent(@buffer.measure_indent(extracted_lines.first), method_name)

      # Find the start of the current method.
      start_of_method = @buffer.grep_backwards_from(line_range.first - 1, /^\s*def/)

      # Build up the new method.
      new_method = []
      new_method << "def #{method_name}"
      new_method += @buffer.reindent(2, extracted_lines)
      new_method << "end"
      new_method << ""

      # Insert the new method before the current method.
      @buffer.append(start_of_method - 1, @buffer.indent(@buffer.measure_indent(@buffer[start_of_method]), new_method))
    end

  end
end

