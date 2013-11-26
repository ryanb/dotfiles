# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# Save and restore settings when creating the explorer buffer.
module LustyM
class SavedSettings
  def initialize
    save()
  end

  def save
    @timeoutlen = VIM::evaluate("&timeoutlen")

    @splitbelow = VIM::evaluate_bool("&splitbelow")
    @insertmode = VIM::evaluate_bool("&insertmode")
    @showcmd = VIM::evaluate_bool("&showcmd")
    @list = VIM::evaluate_bool("&list")
    @hlsearch = VIM::evaluate_bool("&hlsearch")

    @report = VIM::evaluate("&report")
    @sidescroll = VIM::evaluate("&sidescroll")
    @sidescrolloff = VIM::evaluate("&sidescrolloff")

    VIM::command "let s:win_size_restore = winrestcmd()"
  end

  def restore
    VIM::set_option "timeoutlen=#{@timeoutlen}"

    if @splitbelow
      VIM::set_option "splitbelow"
    else
      VIM::set_option "nosplitbelow"
    end

    if @insertmode
      VIM::set_option "insertmode"
    else
      VIM::set_option "noinsertmode"
    end

    if @showcmd
      VIM::set_option "showcmd"
    else
      VIM::set_option "noshowcmd"
    end

    if @list
      VIM::set_option "list"
    else
      VIM::set_option "nolist"
    end

    if @hlsearch
      VIM::set_option "hlsearch"
    else
      VIM::set_option "nohlsearch"
    end

    VIM::command "set report=#{@report}"
    VIM::command "set sidescroll=#{@sidescroll}"
    VIM::command "set sidescrolloff=#{@sidescrolloff}"

    VIM::command "exe s:win_size_restore"
  end
end
end

