# Copyright (C) 2008 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# Maintain MRU ordering.
module LustyM
class BufferStack
  public
    def initialize
      @stack = []

      (0..VIM::Buffer.count-1).each do |i|
        @stack << VIM::Buffer[i].number
      end
    end

    # Switch to the previous buffer (the one you were using before the
    # current one).  This is basically a smarter replacement for :b#,
    # accounting for the situation where your previous buffer no longer
    # exists.
    def juggle_previous
      buf = num_at_pos(2)
      VIM::command "b #{buf}"
    end

    def names(n = :all)
      # Get the last n buffer names by MRU.  Show only as much of
      # the name as necessary to differentiate between buffers of
      # the same name.
      cull!
      names = @stack.collect { |i| VIM::bufname(i) }.reverse
      if n != :all
        names = names[0,n]
      end
      shorten_paths(names)
    end

    def numbers(n = :all)
      # Get the last n buffer numbers by MRU.
      cull!
      numbers = @stack.reverse
      if n == :all
        numbers
      else
        numbers[0,n]
      end
    end

    def num_at_pos(i)
      cull!
      return @stack[-i] ? @stack[-i] : @stack.first
    end

    def length
      cull!
      return @stack.length
    end

    def push
      buf_number = VIM::evaluate('expand("<abuf>")').to_i
      @stack.delete buf_number
      @stack << buf_number
    end

    def pop
      number = VIM::evaluate('bufnr(expand("<abuf>"))')
      @stack.delete number
    end

  private
    def cull!
      # Remove empty and unlisted buffers.
      @stack.delete_if { |x|
        not (VIM::evaluate_bool("bufexists(#{x})") and
             VIM::evaluate_bool("getbufvar(#{x}, '&buflisted')"))
      }
    end

    # NOTE: very similar to Entry::compute_buffer_entries()
    def shorten_paths(buffer_names)
      # Shorten each buffer name by removing all path elements which are not
      # needed to differentiate a given name from other names.  This usually
      # results in only the basename shown, but if several buffers of the
      # same basename are opened, there will be more.

      # Group the buffers by common basename
      common_base = Hash.new { |hash, k| hash[k] = [] }
      buffer_names.each do |name|
        basename = Pathname.new(name).basename.to_s
        common_base[basename] << name
      end

      # Determine the longest common prefix for each basename group.
      basename_to_prefix = {}
      common_base.each do |k, names|
        if names.length > 1
          basename_to_prefix[k] = LustyM::longest_common_prefix(names)
        end
      end

      # Shorten each buffer_name by removing the prefix.
      buffer_names.map { |name|
        base = Pathname.new(name).basename.to_s
        prefix = basename_to_prefix[base]
        prefix ? name[prefix.length..-1] \
               : base
      }
    end
end

end

