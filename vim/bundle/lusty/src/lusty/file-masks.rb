# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

module LustyM
class FileMasks
  private
    @@glob_masks = []

  public
    def FileMasks.create_glob_masks
      @@glob_masks = \
        if VIM::exists? "g:LustyExplorerFileMasks"
          # Note: this variable deprecated.
          VIM::evaluate("g:LustyExplorerFileMasks").split(',')
        elsif VIM::exists? "&wildignore"
          VIM::evaluate("&wildignore").split(',')
        else
          []
        end
    end

    def FileMasks.masked?(str)
      @@glob_masks.each do |mask|
        return true if File.fnmatch(mask, str)
      end

      return false
    end
end
end

