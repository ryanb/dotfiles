"    Copyright: Copyright (C) 2008 Stephen Bach
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               lusty-juggler.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
"
" Name Of File: lusty-juggler.vim
"  Description: Dynamic Buffer Switcher Vim Plugin
"   Maintainer: Stephen Bach <http://items.sjbach.com/about>
" Contributors: Juan Frias, Bartosz Leper, Marco Barberis, Vincent Driessen,
"               Martin Wache, Johannes Holzfuß, Adam Rutkowski, Carlo Teubner,
"               lilydjwg, Leonid Shevtsov, Giuseppe Rota, Göran Gustafsson,
"               Chris Lasher, Guy Haskin Fernald, Thibault Duplessis, Gabriel
"               Pettier
"
" Release Date: February 29, 2012
"      Version: 1.5.1
"
"        Usage:
"                 <Leader>lj  - Opens the buffer juggler.
"
"               You can also use this command:
"
"                 ":LustyJuggler"
"
"               To suppress the default mapping, set this option:
"
"                 let g:LustyJugglerDefaultMappings = 0
"
"               When launched, the command bar at bottom is replaced with a
"               new bar showing the names of currently-opened buffers in
"               most-recently-used order.
"
"               By default, LustyJuggler follows the QWERTY layout, and
"               buffers are mapped to these keys:
"
"                   1st|2nd|3rd|4th|5th|6th|7th|8th|9th|10th
"                   ----------------------------------------
"                   a   s   d   f   g   h   j   k   l   ;
"                   1   2   3   4   5   6   7   8   9   0
"
"               So if you type "f" or "4", the fourth buffer name will be
"               highlighted and the bar will shift to center it as necessary
"               (and show more of the buffer names on the right).
"
"               If you want to switch to that buffer, press "f" or "4" again
"               or press "<ENTER>".  Alternatively, press one of the other
"               mapped keys to highlight another buffer.  To open the buffer
"               in a new split, press "b" for horizontal or "v" for vertical.
"
"               To display the key with the name of the buffer, add one of
"               the following lines to your .vimrc:
"
"                 let g:LustyJugglerShowKeys = 'a'   (for alpha characters)
"                 let g:LustyJugglerShowKeys = 1     (for digits)
"
"               To cancel the juggler, press any of "q", "<ESC>", "<C-c",
"               "<BS>", "<Del>", or "<C-h>".
"
"               LustyJuggler also supports the Dvorak, Colemak, Bépo and aerty
"               keyboard layouts. To enable this feature, place the one of the
"               following in your .vimrc:
"
"                 let g:LustyJugglerKeyboardLayout = "dvorak"
"                 let g:LustyJugglerKeyboardLayout = "colemak"
"                 let g:LustyJugglerKeyboardLayout = "bépo"
"                 let g:LustyJugglerKeyboardLayout = "azerty"
"
"               With the layout set to "dvorak", the buffer mapping is as
"               follows:
"
"                   1st|2nd|3rd|4th|5th|6th|7th|8th|9th|10th
"                   ----------------------------------------
"                   a   o   e   u   i   d   h   t   n   s
"                   1   2   3   4   5   6   7   8   9   0
"
"               With the layout set to "colemak", the buffer mapping is as
"               follows:
"
"                   1st|2nd|3rd|4th|5th|6th|7th|8th|9th|10th
"                   ----------------------------------------
"                   a   r   s   t   d   h   n   e   i   o
"                   1   2   3   4   5   6   7   8   9   0
"
"               With the layout set to "bépo", the buffer mapping is as
"               follows:
"
"                   1st|2nd|3rd|4th|5th|6th|7th|8th|9th|10th
"                   ----------------------------------------
"                   a   u   i   e   ,   t   s   r   n   m
"                   1   2   3   4   5   6   7   8   9   0
"
"               With the layout set to "azerty", the buffer mapping is as
"               follows:
"
"                   1st|2nd|3rd|4th|5th|6th|7th|8th|9th|10th
"                   ----------------------------------------
"                   q   s   d   f   g   j   k   l   m   ù
"                   1   2   3   4   5   6   7   8   9   0
"
"               LustyJuggler can act very much like <A-Tab> window switching.
"               To enable this mode, add the following line to your .vimrc:
"
"                 let g:LustyJugglerAltTabMode = 1
"
"               Then, given the following mapping:
"
"                 noremap <silent> <A-s> :LustyJuggler<CR>
"
"               Pressing "<A-s>" will launch the LustyJuggler with the
"               previous buffer highlighted. Typing "<A-s>" again will cycle
"               to the next buffer (in most-recently used order), and
"               "<ENTER>" will open the highlighted buffer.  For example, the
"               sequence "<A-s><Enter>" will open the previous buffer, and
"               "<A-s><A-s><Enter>" will open the buffer used just before the
"               previous buffer, and so on.
"
"        Bonus: This plugin also includes the following command, which will
"               immediately switch to your previously used buffer:
"
"                 ":LustyJugglePrevious"
"
"               This is similar to the ":b#" command, but accounts for the
"               common situation where the previously used buffer (#) has
"               been killed and is thus inaccessible.  In that case, it will
"               instead switch to the buffer used before that one (and on down
"               the line if that buffer has been killed too).
"
"
" Install Details:
"
" Copy this file into $HOME/.vim/plugin directory so that it will be sourced
" on startup automatically.
"
" Note! This plugin requires Vim be compiled with Ruby interpretation.  If you
" don't know if your build of Vim has this functionality, you can check by
" running "vim --version" from the command line and looking for "+ruby".
" Alternatively, just try sourcing this script.
"
" If your version of Vim does not have "+ruby" but you would still like to
" use this plugin, you can fix it.  See the "Check for Ruby functionality"
" comment below for instructions.
"
" If you are using the same Vim configuration and plugins for multiple
" machines, some of which have Ruby and some of which don't, you may want to
" turn off the "Sorry, LustyJuggler requires ruby" warning.  You can do so
" like this (in .vimrc):
"
"   let g:LustyJugglerSuppressRubyWarning = 1
"
"
" Contributing:
"
" Patches and suggestions welcome.  Note: lusty-juggler.vim is a generated
" file; if you'd like to submit a patch, check out the Github development
" repository:
"
"    http://github.com/sjbach/lusty
"
"
" GetLatestVimScripts: 2050 1 :AutoInstall: lusty-juggler.vim
"
" TODO:
" - Add TAB recognition back.
" - Add option to open buffer immediately when mapping is pressed (but not
"   release the juggler until the confirmation press).
" - Have the delimiter character settable.
"   - have colours settable?

" Exit quickly when already loaded.
if exists("g:loaded_lustyjuggler")
  finish
endif

if &compatible
  echohl ErrorMsg
  echo "LustyJuggler is not designed to run in &compatible mode;"
  echo "To use this plugin, first disable vi-compatible mode like so:\n"

  echo "   :set nocompatible\n"

  echo "Or even better, just create an empty .vimrc file."
  echohl none
  finish
endif

if exists("g:FuzzyFinderMode.TextMate")
  echohl WarningMsg
  echo "Warning: LustyJuggler detects the presence of fuzzyfinder_textmate;"
  echo "that plugin often interacts poorly with other Ruby plugins."
  echo "If LustyJuggler gives you an error, you can probably fix it by"
  echo "renaming fuzzyfinder_textmate.vim to zzfuzzyfinder_textmate.vim so"
  echo "that it is last in the load order."
  echohl none
endif

" Check for Ruby functionality.
if !has("ruby")
  if !exists("g:LustyExplorerSuppressRubyWarning") ||
      \ g:LustyExplorerSuppressRubyWarning == "0"
  if !exists("g:LustyJugglerSuppressRubyWarning") ||
      \ g:LustyJugglerSuppressRubyWarning == "0"
    echohl ErrorMsg
    echon "Sorry, LustyJuggler requires ruby.  "
    echon "Here are some tips for adding it:\n"

    echo "Debian / Ubuntu:"
    echo "    # apt-get install vim-ruby\n"

    echo "Fedora:"
    echo "    # yum install vim-enhanced\n"

    echo "Gentoo:"
    echo "    # USE=\"ruby\" emerge vim\n"

    echo "FreeBSD:"
    echo "    # pkg_add -r vim+ruby\n"

    echo "Windows:"
    echo "    1. Download and install Ruby from here:"
    echo "       http://www.ruby-lang.org/"
    echo "    2. Install a Vim binary with Ruby support:"
    echo "       http://segfault.hasno.info/vim/gvim72.zip\n"

    echo "Manually (including Cygwin):"
    echo "    1. Install Ruby."
    echo "    2. Download the Vim source package (say, vim-7.0.tar.bz2)"
    echo "    3. Build and install:"
    echo "         # tar -xvjf vim-7.0.tar.bz2"
    echo "         # ./configure --enable-rubyinterp"
    echo "         # make && make install\n"

    echo "(If you just wish to stifle this message, set the following option:"
    echo "  let g:LustyJugglerSuppressRubyWarning = 1)"
    echohl none
  endif
  endif
  finish
endif

let g:loaded_lustyjuggler = "yep"

" Commands.
command LustyJuggler :call <SID>LustyJugglerStart()
command LustyJugglePrevious :call <SID>LustyJugglePreviousRun()

" Deprecated command names.
command JugglePrevious :call
  \ <SID>deprecated('JugglePrevious', 'LustyJugglePrevious')

function! s:deprecated(old, new)
  echohl WarningMsg
  echo ":" . a:old . " is deprecated; use :" . a:new . " instead."
  echohl none
endfunction


" Default mappings.
if !exists("g:LustyJugglerDefaultMappings")
  let g:LustyJugglerDefaultMappings = 1
endif

if g:LustyJugglerDefaultMappings == 1
  nmap <silent> <Leader>lj :LustyJuggler<CR>
endif

" Vim-to-ruby function calls.
function! s:LustyJugglerStart()
  ruby LustyJ::profile() { $lusty_juggler.run }
endfunction

function! s:LustyJugglerKeyPressed(code_arg)
  ruby LustyJ::profile() { $lusty_juggler.key_pressed }
endfunction

function! s:LustyJugglerCancel()
  ruby LustyJ::profile() { $lusty_juggler.cleanup }
endfunction

function! s:LustyJugglePreviousRun()
  ruby LustyJ::profile() { $lj_buffer_stack.juggle_previous }
endfunction

" Setup the autocommands that handle buffer MRU ordering.
augroup LustyJuggler
  autocmd!
  autocmd BufAdd,BufEnter * ruby LustyJ::profile() { $lj_buffer_stack.push }
  autocmd BufDelete * ruby LustyJ::profile() { $lj_buffer_stack.pop }
  autocmd BufWipeout * ruby LustyJ::profile() { $lj_buffer_stack.pop }
augroup End

" Used to work around a flaw in Vim's ruby bindings.
let s:maparg_holder = 0
let s:maparg_dict_holder = { }

ruby << EOF

require 'pathname'

$LUSTY_PROFILING = false

if $LUSTY_PROFILING
  require 'rubygems'
  require 'ruby-prof'
end


{{RUBY_CODE_INSERTION_POINT}}

if VIM::exists?('g:LustyJugglerKeyboardLayout') and VIM::evaluate_bool('g:LustyJugglerKeyboardLayout == "dvorak"')
  $lusty_juggler = LustyJ::LustyJugglerDvorak.new
elsif VIM::exists?('g:LustyJugglerKeyboardLayout') and VIM::evaluate_bool('g:LustyJugglerKeyboardLayout == "colemak"')
  $lusty_juggler = LustyJ::LustyJugglerColemak.new
elsif VIM::exists?('g:LustyJugglerKeyboardLayout') and VIM::evaluate_bool('g:LustyJugglerKeyboardLayout == "bépo"')
	$lusty_juggler = LustyJ::LustyJugglerBepo.new
elsif VIM::exists?('g:LustyJugglerKeyboardLayout') and VIM::evaluate_bool('g:LustyJugglerKeyboardLayout == "azerty"')
	$lusty_juggler = LustyJ::LustyJugglerAzerty.new
else 
  $lusty_juggler = LustyJ::LustyJuggler.new
end
$lj_buffer_stack = LustyJ::BufferStack.new

EOF

" vim: set sts=2 sw=2:
