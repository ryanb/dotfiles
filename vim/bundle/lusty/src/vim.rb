# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

module VIM

  unless const_defined? "MOST_POSITIVE_INTEGER"
    MOST_POSITIVE_INTEGER = 2**(32 - 1) - 2  # Vim ints are signed 32-bit.
  end

  def self.zero?(var)
    # In Vim 7.2 and older, VIM::evaluate returns Strings for boolean
    # expressions; in later versions, Fixnums.
    case var
    when String
      var == "0"
    when Fixnum
      var == 0
    else
      LustyM::assert(false, "unexpected type: #{var.class}")
    end
  end

  def self.nonzero?(var)
    not zero?(var)
  end

  def self.evaluate_bool(var)
    nonzero? evaluate(var)
  end

  def self.exists?(s)
    nonzero? evaluate("exists('#{s}')")
  end

  def self.has_syntax?
    nonzero? evaluate('has("syntax")')
  end

  def self.has_ext_maparg?
    # The 'dict' parameter to mapargs() was introduced in Vim 7.3.32
    nonzero? evaluate('v:version > 703 || (v:version == 703 && has("patch32"))')
  end

  def self.columns
    evaluate("&columns").to_i
  end

  def self.lines
    evaluate("&lines").to_i
  end

  def self.getcwd
    evaluate("getcwd()")
  end

  def self.bufname(i)
    if evaluate_bool("empty(bufname(#{i}))")
      "<Unknown #{i}>"
    else
      evaluate("bufname(#{i})")
    end
  end

  def self.single_quote_escape(s)
    # Everything in a Vim single-quoted string is literal, except single
    # quotes.  Single quotes are escaped by doubling them.
    s.gsub("'", "''")
  end

  def self.regex_escape(s)
    s.gsub(/[\]\[.~"^$\\*]/,'\\\\\0')
  end

  class Buffer
    def modified?
      VIM::nonzero? VIM::evaluate("getbufvar(#{number()}, '&modified')")
    end

    def listed?
      VIM::nonzero? VIM::evaluate("getbufvar(#{number()}, '&buflisted')")
    end

    def self.obj_for_bufnr(n)
      # There's gotta be a better way to do this...
      (0..VIM::Buffer.count-1).each do |i|
        obj = VIM::Buffer[i]
        return obj if obj.number == n
      end

      return nil
    end
  end

  # Print with colours
  def self.pretty_msg(*rest)
    return if rest.length == 0
    return if rest.length % 2 != 0

    command "redraw"  # see :help echo-redraw
    i = 0
    while i < rest.length do
      command "echohl #{rest[i]}"
      command "echon '#{rest[i+1]}'"
      i += 2
    end

    command 'echohl None'
  end
end

# Hack for wide CJK characters.
if VIM::exists?("*strwidth")
  module VIM
    def self.strwidth(s)
      # strwidth() is defined in Vim 7.3.
      evaluate("strwidth('#{single_quote_escape(s)}')").to_i
    end
  end
else
  module VIM
    def self.strwidth(s)
      s.length
    end
  end
end

if VIM::exists?("*fnameescape")
  module VIM
    def self.filename_escape(s)
      # Escape slashes, open square braces, spaces, sharps, double
      # quotes and percent signs, and remove leading ./ for files in
      # pwd.
      single_quote_escaped = single_quote_escape(s)
      evaluate("fnameescape('#{single_quote_escaped}')").sub(/^\.\//,"")
    end
  end
else
  module VIM
    def self.filename_escape(s)
      # Escape slashes, open square braces, spaces, sharps, double
      # quotes and percent signs, and remove leading ./ for files in
      # pwd.
      s.gsub(/\\/, '\\\\\\').gsub(/[\[ #"%]/, '\\\\\0').sub(/^\.\//,"")
    end
  end
end

