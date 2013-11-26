# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

module LustyM

# Used in BufferExplorer
class Prompt
  private
    @@PROMPT = ">> "

  public
    def initialize
      clear!
    end

    def clear!
      @input = ""
    end

    def print(max_width = 0)
      text = @input
      # may need some extra characters for "..." and spacing
      max_width -= 5
      if max_width > 0 && text.length > max_width
        text = "..." + text[(text.length - max_width + 3 ) .. -1]
      end

      VIM::pretty_msg("Comment", @@PROMPT,
                      "None", VIM::single_quote_escape(text),
                      "Underlined", " ")
    end

    def set!(s)
      @input = s
    end

    def input
      @input
    end

    def insensitive?
      @input == @input.downcase
    end

    def ends_with?(c)
      LustyM::ends_with?(@input, c)
    end

    def add!(s)
      @input << s
    end

    def backspace!
      @input.chop!
    end

    def up_one_dir!
      @input.chop!
      while !@input.empty? and @input[-1] != ?/
        @input.chop!
      end
    end
end

# Used in FilesystemExplorer
class FilesystemPrompt < Prompt

  def initialize
    super
    @memoized = nil
    @dirty = true
  end

  def clear!
    super
    @dirty = true
  end

  def set!(s)
    # On Windows, Vim will return paths with a '\' separator, but
    # we want to use '/'.
    super(s.gsub('\\', '/'))
    @dirty = true
  end

  def backspace!
    super
    @dirty = true
  end

  def up_one_dir!
    super
    @dirty = true
  end

  def at_dir?
    # We have not typed anything yet or have just typed the final '/' on a
    # directory name in pwd.  This check is interspersed throughout
    # FilesystemExplorer because of the conventions of basename and dirname.
    input().empty? or input()[-1] == File::SEPARATOR[0]
    # Don't think the File.directory? call is necessary, but leaving this
    # here as a reminder.
    #(File.directory?(input()) and input().ends_with?(File::SEPARATOR))
  end

  def insensitive?
    at_dir? or (basename() == basename().downcase)
  end

  def add!(s)
    # Assumption: add!() will only receive enough chars at a time to complete
    # a single directory level, e.g. foo/, not foo/bar/

    @input << s
    @dirty = true
  end

  def input
    if @dirty
      @memoized = LustyM::simplify_path(variable_expansion(@input))
      @dirty = false
    end

    @memoized
  end

  def basename
    File.basename input()
  end

  def dirname
    File.dirname input()
  end

  private
    def variable_expansion (input_str)
      strings = input_str.split('$', -1)
      return "" if strings.nil? or strings.length == 0

      first = strings.shift

      # Try to expand each instance of $<word>.
      strings.inject(first) { |str, s|
        if s =~ /^(\w+)/ and ENV[$1]
          str + s.sub($1, ENV[$1])
        else
          str + "$" + s
        end
      }
    end
end

end

