# Copyright (C) 2008 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# An item (delimiter/separator or buffer name) on the NameBar.
module LustyM
class BarItem
  def initialize(str, color)
    @str = str
    @color = color
  end

  def length
    @str.length
  end

  def pretty_print_input
    [@color, @str]
  end

  def [](*rest)
    return BarItem.new(@str[*rest], @color)
  end

  def self.full_length(array)
    if array
      array.inject(0) { |sum, el| sum + el.length }
    else
      0
    end
  end
end

class BufferItem < BarItem
  def initialize(str, highlighted)
    @str = str
    @highlighted = highlighted
    destructure()
  end

  def [](*rest)
    return BufferItem.new(@str[*rest], @highlighted)
  end

  def pretty_print_input
    @array
  end

  private
    @@BUFFER_COLOR = "PreProc"
    #@@BUFFER_COLOR = "None"
    @@DIR_COLOR = "Directory"
    @@SLASH_COLOR = "Function"
    @@HIGHLIGHTED_COLOR = "Question"

    # Breakdown the string to colourize each part.
    def destructure
      if @highlighted
        buf_color = @@HIGHLIGHTED_COLOR
        dir_color = @@HIGHLIGHTED_COLOR
        slash_color = @@HIGHLIGHTED_COLOR
      else
        buf_color = @@BUFFER_COLOR
        dir_color = @@DIR_COLOR
        slash_color = @@SLASH_COLOR
      end

      pieces = @str.split(File::SEPARATOR, -1)

      @array = []
      @array << dir_color
      @array << pieces.shift
      pieces.each { |piece|
        @array << slash_color
        @array << File::SEPARATOR
        @array << dir_color
        @array << piece
      }

      # Last piece is the actual name.
      @array[-2] = buf_color
    end
end

class SeparatorItem < BarItem
  public
    def initialize
      super(@@TEXT, @@COLOR)
    end

  private
    @@TEXT = "|"
    #@@COLOR = "NonText"
    @@COLOR = "None"
end

class LeftContinuerItem < BarItem
  public
    def initialize
      super(@@TEXT, @@COLOR)
    end

    def self.length
      @@TEXT.length
    end

  private
    @@TEXT = "<"
    @@COLOR = "NonText"
end

class RightContinuerItem < BarItem
  public
    def initialize
      super(@@TEXT, @@COLOR)
    end

    def self.length
      @@TEXT.length
    end

  private
    @@TEXT = ">"
    @@COLOR = "NonText"
end

end

