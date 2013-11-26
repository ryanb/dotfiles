# Copyright (C) 2008 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# A one-line display of the open buffers, appearing in the command display.
module LustyM
class NameBar
  public
    def initialize(letters)
      @selected_buffer = nil
      @LETTERS = letters
    end

    attr_writer :selected_buffer

    def print
      items = create_items()

      selected_item = \
        if @selected_buffer
          # Account for the separators we've added.
          [@selected_buffer * 2, (items.length - 1)].min
        end

      clipped = clip(items, selected_item)
      NameBar.do_pretty_print(clipped)
    end


    def create_items
      names = $lj_buffer_stack.names(10)

      items = names.inject([]) { |array, name|
        key = if VIM::exists?("g:LustyJugglerShowKeys")
                case VIM::evaluate("g:LustyJugglerShowKeys").to_s
                when /[[:alpha:]]/
                  @LETTERS[array.size / 2] + ":"
                when /[[:digit:]]/
                  "#{((array.size / 2) + 1) % 10}:"
                else
                  ""
                end
              else
                ""
              end

        array << BufferItem.new("#{key}#{name}",
                            (@selected_buffer and \
                             name == names[@selected_buffer]))
        array << SeparatorItem.new
      }
      items.pop   # Remove last separator.

      return items
    end

    # Clip the given array of items to the available display width.
    def clip(items, selected)
      # This function is pretty hard to follow...

      # Note: Vim gives the annoying "Press ENTER to continue" message if we
      # use the full width.
      columns = VIM::columns() - 1

      if BarItem.full_length(items) <= columns
        return items
      end

      selected = 0 if selected.nil?
      half_displayable_len = columns / 2

      # The selected buffer is excluded since it's basically split between
      # the sides.
      left_len = BarItem.full_length items[0, selected - 1]
      right_len = BarItem.full_length items[selected + 1, items.length - 1]

      right_justify = (left_len > half_displayable_len) and \
                      (right_len < half_displayable_len)

      selected_str_half_len = (items[selected].length / 2) + \
                              (items[selected].length % 2 == 0 ? 0 : 1)

      if right_justify
        # Right justify the bar.
        first_layout = self.method :layout_right
        second_layout = self.method :layout_left
        first_adjustment = selected_str_half_len
        second_adjustment = -selected_str_half_len
      else
        # Left justify (sort-of more likely).
        first_layout = self.method :layout_left
        second_layout = self.method :layout_right
        first_adjustment = -selected_str_half_len
        second_adjustment = selected_str_half_len
      end

      # Layout the first side.
      allocation = half_displayable_len + first_adjustment
      first_side, remainder = first_layout.call(items,
                                                selected,
                                                allocation)

      # Then layout the second side, also grabbing any unused space.
      allocation = half_displayable_len + \
                   second_adjustment + \
                   remainder
      second_side, remainder = second_layout.call(items,
                                                  selected,
                                                  allocation)

      if right_justify
        second_side + first_side
      else
        first_side + second_side
      end
    end

    # Clip the given array of items to the given space, counting downwards.
    def layout_left(items, selected, space)
      trimmed = []

      i = selected - 1
      while i >= 0
        m = items[i]
        if space > m.length
          trimmed << m
          space -= m.length
        elsif space > 0
          trimmed << m[m.length - (space - LeftContinuerItem.length), \
                       space - LeftContinuerItem.length]
          trimmed << LeftContinuerItem.new
          space = 0
        else
          break
        end
        i -= 1
      end

      return trimmed.reverse, space
    end

    # Clip the given array of items to the given space, counting upwards.
    def layout_right(items, selected, space)
      trimmed = []

      i = selected
      while i < items.length
        m = items[i]
        if space > m.length
          trimmed << m
          space -= m.length
        elsif space > 0
          trimmed << m[0, space - RightContinuerItem.length]
          trimmed << RightContinuerItem.new
          space = 0
        else
          break
        end
        i += 1
      end

      return trimmed, space
    end

    def NameBar.do_pretty_print(items)
      args = items.inject([]) { |array, item|
        array = array + item.pretty_print_input
      }

      VIM::pretty_msg *args
    end
end

end

