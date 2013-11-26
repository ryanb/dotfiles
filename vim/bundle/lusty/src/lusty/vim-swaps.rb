# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

module LustyM
class VimSwaps
  def initialize
    if VIM::has_syntax?
# FIXME: vvv disabled
#      @vim_r = IO.popen("vim -r --noplugin -i NONE 2>&1")
#      @files_with_swaps = nil
      @files_with_swaps = []
    else
      @files_with_swaps = []
    end
  end

  def file_names
    if @files_with_swaps.nil?
      if LustyM::ready_for_read?(@vim_r)
        @files_with_swaps = []
        @vim_r.each_line do |line|
          if line =~ /^ +file name: (.*)$/
            file = $1.chomp
            @files_with_swaps << Pathname.new(LustyM::simplify_path(file))
          end
        end
      else
        return []
      end
    end

    @files_with_swaps
  end
end
end

