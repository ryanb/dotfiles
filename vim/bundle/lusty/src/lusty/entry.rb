# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

module LustyM

# Abstract base class.
class Entry
  attr_accessor :full_name, :short_name, :label
  def initialize(full_name, short_name, label)
    @full_name = full_name
    @short_name = short_name
    @label = label
  end

  # NOTE: very similar to BufferStack::shorten_paths()
  def self.compute_buffer_entries()
    buffer_entries = []

    $le_buffer_stack.numbers.each do |n|
      o = VIM::Buffer.obj_for_bufnr(n)
      next if (o.nil? or not o.listed?)
      buffer_entries << self.new(o, n)
    end

    # Put the current buffer at the end of the list.
    buffer_entries << buffer_entries.shift

    # Shorten each buffer name by removing all path elements which are not
    # needed to differentiate a given name from other names.  This usually
    # results in only the basename shown, but if several buffers of the
    # same basename are opened, there will be more.

    # Group the buffers by common basename
    common_base = Hash.new { |hash, k| hash[k] = [] }
    buffer_entries.each do |entry|
      if entry.full_name
        basename = Pathname.new(entry.full_name).basename.to_s
        common_base[basename] << entry
      end
    end

    # Determine the longest common prefix for each basename group.
    basename_to_prefix = {}
    common_base.each do |base, entries|
      if entries.length > 1
        full_names = entries.map { |e| e.full_name }
        basename_to_prefix[base] = LustyM::longest_common_prefix(full_names)
      end
    end

    # Compute shortened buffer names by removing prefix, if possible.
    buffer_entries.each do |entry|
      full_name = entry.full_name

      short_name = if full_name.nil?
                     '[No Name]'
                   elsif LustyM::starts_with?(full_name, "scp://")
                     full_name
                   else
                     base = Pathname.new(full_name).basename.to_s
                     prefix = basename_to_prefix[base]

                     prefix ? full_name[prefix.length..-1] \
                            : base
                   end

      entry.short_name = short_name
    end

    buffer_entries
  end
end

# Used in FilesystemExplorer
class FilesystemEntry < Entry
  attr_accessor :current_score
  def initialize(label)
    super("::UNSET::", "::UNSET::", label)
    @current_score = 0.0
  end
end

# Used in BufferExplorer
class BufferEntry < Entry
  attr_accessor :vim_buffer, :mru_placement, :current_score
  def initialize(vim_buffer, mru_placement)
    super(vim_buffer.name, "::UNSET::", "::UNSET::")
    @vim_buffer = vim_buffer
    @mru_placement = mru_placement
    @current_score = 0.0
  end
end

# Used in BufferGrep
class GrepEntry < Entry
  attr_accessor :vim_buffer, :mru_placement, :line_number
  def initialize(vim_buffer, mru_placement)
    super(vim_buffer.name, "::UNSET::", "::UNSET::")
    @vim_buffer = vim_buffer
    @mru_placement = mru_placement
    @line_number = 0
  end
end

end

