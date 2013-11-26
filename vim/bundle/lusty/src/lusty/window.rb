# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# Simplify switching between windows.
module LustyM
class Window
    def self.select(window)
      return true if window == $curwin

      start = $curwin

      # Try to select the given window.
      begin
        VIM::command "wincmd w"
      end while ($curwin != window) and ($curwin != start)

      if $curwin == window
        return true
      else
        # Failed -- re-select the starting window.
        VIM::command("wincmd w") while $curwin != start
        VIM::pretty_msg("ErrorMsg", "Cannot find the correct window!")
        return false
      end
    end
end
end

