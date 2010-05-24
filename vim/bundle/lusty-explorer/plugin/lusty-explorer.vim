"    Copyright: Copyright (C) 2007-2010 Stephen Bach
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               lusty-explorer.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
"
" Name Of File: lusty-explorer.vim
"  Description: Dynamic Filesystem and Buffer Explorer Vim Plugin
"  Maintainers: Stephen Bach <this-file@sjbach.com>
"               Matt Tolton <matt-lusty-explorer@tolton.com>
" Contributors: Raimon Grau, Sergey Popov, Yuichi Tateno, Bernhard Walle,
"               Rajendra Badapanda, cho45, Simo Salminen, Sami Samhuri,
"               Matt Tolton, Björn Winckler, sowill, David Brown
"               Brett DiFrischia, Ali Asad Lotia
"
" Release Date: March 28, 2010
"      Version: 2.3.0
"
"        Usage: To launch the explorers:
"
"                 <Leader>lf  - Opens the filesystem explorer.
"                 <Leader>lr  - Opens the filesystem explorer from the parent
"                               directory of the current file.
"                 <Leader>lb  - Opens the buffer explorer.
"
"               You can also use the commands:
"
"                 ":LustyFilesystemExplorer"
"                 ":LustyFilesystemExplorerFromHere"
"                 ":LustyBufferExplorer"
"
"               (Personally, I map these to ,f and ,r and ,b)
"
"               The interface is intuitive.  When one of the explorers is
"               launched, a new window appears at bottom presenting a list of
"               files/dirs or buffers, and in the status bar is a prompt:
"
"                 >>
"
"               As you type, the list updates for possible matches using a
"               fuzzy matching algorithm.  Special keys include:
"
"                 <Enter>  open the selected match
"                 <Tab>    open the selected match
"                 <Esc>    cancel
"                 <C-c>    cancel
"                 <C-g>    cancel
"
"                 <C-t>    open selected match in a new [t]ab
"                 <C-o>    open selected match in a new h[o]rizontal split
"                 <C-v>    open selected match in a new [v]ertical split
"
"                 <C-n>    select the [n]ext match
"                 <C-p>    select the [p]revious match
"
"                 <C-w>    ascend one directory at prompt
"                 <C-u>    clear the prompt
"
"               Additional shortcuts for the filesystem explorer:
"
"                 <C-r>    [r]efresh directory contents
"                 <C-a>    open [a]ll files in the current list
"                 <C-e>    create a new buffer with the given name and path
"
" Buffer Explorer:
"  - The currently active buffer is highlighted.
"  - Buffers are listed without path unless needed to differentiate buffers of
"    the same name.
"
" Filesystem Explorer:
"  - Directory contents are memoized.
"  - You can recurse into and out of directories by typing the directory name
"    and a slash, e.g. "stuff/" or "../".
"  - Variable expansion, e.g. "$D" -> "/long/dir/path/".
"  - Tilde (~) expansion, e.g. "~/" -> "/home/steve/".
"  - Dotfiles are hidden by default, but are shown if the current search term
"    begins with a '.'.  To show these file at all times, set this option:
"
"       let g:LustyExplorerAlwaysShowDotFiles = 1
"
"  You can prevent certain files from appearing in the directory listings with
"  the following variable:
"
"    set wildignore=*.o,*.fasl,CVS
"
"  The above example will mask all object files, compiled lisp files, and
"  files/directories named CVS from appearing in the filesystem explorer.
"  Note that they can still be opened by being named explicitly.
"
"  See :help 'wildignore' for more information.
"
"
" Install Details:
"
" Copy this file into your $HOME/.vim/plugin directory so that it will be
" sourced on startup automatically.
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
" turn off the "Sorry, LustyExplorer requires ruby" warning.  You can do so
" like this (in .vimrc):
"
"   let g:LustyExplorerSuppressRubyWarning = 1
"
" GetLatestVimScripts: 1890 1 :AutoInstall: lusty-explorer.vim
"
" TODO:
" - when an edited file is in nowrap mode and the explorer is called while the
"   current window is scrolled to the right, name truncation occurs.
" - enable VimSwaps stuff
"   - set callback when pipe is ready for read and force refresh()
" - uppercase character should make flex matching case-sensitive
" - FilesystemExplorerRecursive
" - restore MRU buffer ordering for initial BufferExplorer display?
" - C-jhkl navigation to highlight a file?
" - abbrev "a" will score e.g. "m-a" higher than e.g. "ad"

" Exit quickly when already loaded.
if exists("g:loaded_lustyexplorer")
  finish
endif

if &compatible
  echohl ErrorMsg
  echo "LustyExplorer is not designed to run in &compatible mode;"
  echo "To use this plugin, first disable vi-compatible mode like so:\n"

  echo "   :set nocompatible\n"

  echo "Or even better, just create an empty .vimrc file."
  echohl none
  finish
endif

if exists("g:FuzzyFinderMode.TextMate")
  echohl WarningMsg
  echo "Warning: LustyExplorer detects the presence of fuzzyfinder_textmate;"
  echo "that plugin sometimes interacts poorly with other Ruby plugins."
  echohl none
endif

" Check for Ruby functionality.
if !has("ruby") || version < 700
  if !exists("g:LustyExplorerSuppressRubyWarning") ||
     \ g:LustyExplorerSuppressRubyWarning == "0"
  if !exists("g:LustyJugglerSuppressRubyWarning") ||
      \ g:LustyJugglerSuppressRubyWarning == "0"
    echohl ErrorMsg
    echon "Sorry, LustyExplorer requires ruby.  "
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
    echo "         # make && make install"

    echo "(If you just wish to stifle this message, set the following option:"
    echo "  let g:LustyJugglerSuppressRubyWarning = 1)"
    echohl none
  endif
  endif
  finish
endif

if ! &hidden
  echohl WarningMsg
  echo "You are running with 'hidden' mode off.  LustyExplorer may"
  echo "sometimes emit error messages in this mode -- you should turn"
  echo "it on, like so:\n"

  echo "   :set hidden\n"

  echo "Even better, put this in your .vimrc file."
  echohl none
endif

let g:loaded_lustyexplorer = "yep"

" Commands.
command LustyBufferExplorer :call <SID>LustyBufferExplorerStart()
command LustyFilesystemExplorer :call <SID>LustyFilesystemExplorerStart()
command LustyFilesystemExplorerFromHere :call <SID>LustyFilesystemExplorerFromHereStart()

" Deprecated command names.
command BufferExplorer :call
  \ <SID>deprecated('BufferExplorer', 'LustyBufferExplorer')
command FilesystemExplorer :call
  \ <SID>deprecated('FilesystemExplorer', 'LustyFilesystemExplorer')
command FilesystemExplorerFromHere :call
  \ <SID>deprecated('FilesystemExplorerFromHere',
  \                 'LustyFilesystemExplorerFromHere')

function! s:deprecated(old, new)
  echohl WarningMsg
  echo ":" . a:old . " is deprecated; use :" . a:new . " instead."
  echohl none
endfunction


" Default mappings.
nmap <silent> <Leader>lf :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>lr :LustyFilesystemExplorerFromHere<CR>
nmap <silent> <Leader>lb :LustyBufferExplorer<CR>

" Vim-to-ruby function calls.
function! s:LustyFilesystemExplorerStart()
  ruby Lusty::profile() { $lusty_filesystem_explorer.run_from_wd }
endfunction

function! s:LustyFilesystemExplorerFromHereStart()
  ruby Lusty::profile() { $lusty_filesystem_explorer.run_from_here }
endfunction

function! s:LustyBufferExplorerStart()
  ruby Lusty::profile() { $lusty_buffer_explorer.run }
endfunction

function! s:LustyFilesystemExplorerCancel()
  ruby Lusty::profile() { $lusty_filesystem_explorer.cancel }
endfunction

function! s:LustyBufferExplorerCancel()
  ruby Lusty::profile() { $lusty_buffer_explorer.cancel }
endfunction

function! s:LustyFilesystemExplorerKeyPressed(code_arg)
  ruby Lusty::profile() { $lusty_filesystem_explorer.key_pressed }
endfunction

function! s:LustyBufferExplorerKeyPressed(code_arg)
  ruby Lusty::profile() { $lusty_buffer_explorer.key_pressed }
endfunction

ruby << EOF

require 'pathname'
# For IO#ready -- but Cygwin doesn't have io/wait.
require 'io/wait' unless RUBY_PLATFORM =~ /cygwin/
# Needed for String#each_char in Ruby 1.8 on some platforms.
require 'jcode' unless "".respond_to? :each_char
# Needed for Array#each_slice in Ruby 1.8 on some platforms.
require 'enumerator' unless [].respond_to? :each_slice

$LUSTY_PROFILING = false

if $LUSTY_PROFILING
  require 'rubygems'
  require 'ruby-prof'
end


module VIM
  MOST_POSITIVE_INTEGER = 2**(32 - 1) - 2  # Vim ints are signed 32-bit.

  def self.zero?(var)
    # In Vim 7.2 and older, VIM::evaluate returns Strings for boolean
    # expressions; in later versions, Fixnums.
    case var
    when String
      var == "0"
    when Fixnum
      var == 0
    else
      Lusty::assert(false, "unexpected type: #{var.class}")
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

  def self.columns
    evaluate("&columns").to_i
  end

  def self.lines
    evaluate("&lines").to_i
  end

  def self.getcwd
    evaluate("getcwd()")
  end

  def self.single_quote_escape(s)
    # Everything in a Vim single-quoted string is literal, except single
    # quotes.  Single quotes are escaped by doubling them.
    s.gsub("'", "''")
  end

  def self.filename_escape(s)
    # Escape slashes, open square braces, spaces, sharps, and double quotes.
    s.gsub(/\\/, '\\\\\\').gsub(/[\[ #"]/, '\\\\\0')
  end

  def self.regex_escape(s)
    s.gsub(/[\]\[.~"^$\\*]/,'\\\\\0')
  end

  class Buffer
    def modified?
      VIM::nonzero? VIM::evaluate("getbufvar(#{number()}, '&modified')")
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


# Utility functions.
module Lusty
  MOST_POSITIVE_FIXNUM = 2**(0.size * 8 -2) -1

  def self.simplify_path(s)
    s = s.gsub(/\/+/, '/')  # Remove redundant '/' characters
    begin
      if s[0] == ?~
        # Tilde expansion - First expand the ~ part (e.g. '~' or '~steve')
        # and then append the rest of the path.  We can't just call
        # expand_path() or it'll throw on bad paths.
        s = File.expand_path(s.sub(/\/.*/,'')) + \
            s.sub(/^[^\/]+/,'')
      end

      if s == '/'
        # Special-case root so we don't add superfluous '/' characters,
        # as this can make Cygwin choke.
        s
      elsif ends_with?(s, File::SEPARATOR)
        File.expand_path(s) + File::SEPARATOR
      else
        dirname_expanded = File.expand_path(File.dirname(s))
        if dirname_expanded == '/'
          dirname_expanded + File.basename(s)
        else
          dirname_expanded + File::SEPARATOR + File.basename(s)
        end
      end
    rescue ArgumentError
      s
    end
  end

  def self.ready_for_read?(io)
    if io.respond_to? :ready?
      ready?
    else
      result = IO.select([io], nil, nil, 0)
      result && (result.first.first == io)
    end
  end

  def self.ends_with?(s1, s2)
    tail = s1[-s2.length, s2.length]
    tail == s2
  end

  def self.starts_with?(s1, s2)
    head = s1[0, s2.length]
    head == s2
  end

  def self.option_set?(opt_name)
    opt_name = "g:LustyExplorer" + opt_name
    VIM::evaluate_bool("exists('#{opt_name}') && #{opt_name} != '0'")
  end

  def self.profile
    # Profile (if enabled) and provide better
    # backtraces when there's an error.

    if $LUSTY_PROFILING
      if not RubyProf.running?
        RubyProf.measure_mode = RubyProf::WALL_TIME
        RubyProf.start
      else
        RubyProf.resume
      end
    end

    begin
      yield
    rescue Exception => e
      puts e
      puts e.backtrace
    end

    if $LUSTY_PROFILING and RubyProf.running?
      RubyProf.pause
    end
  end

  class AssertionError < StandardError ; end

  def self.assert(condition, message = 'assertion failure')
    raise AssertionError.new(message) unless condition
  end

  def self.d(s)
    # (Debug print)
    $stderr.puts s
  end
end


# Port of Ryan McGeary's LiquidMetal fuzzy matching algorithm found at:
#   http://github.com/rmm5t/liquidmetal/tree/master.
module LiquidMetal
  @@SCORE_NO_MATCH = 0.0
  @@SCORE_MATCH = 1.0
  @@SCORE_TRAILING = 0.8
  @@SCORE_TRAILING_BUT_STARTED = 0.90
  @@SCORE_BUFFER = 0.85

  def self.score(string, abbrev)

    return @@SCORE_TRAILING if abbrev.empty?
    return @@SCORE_NO_MATCH if abbrev.length > string.length

    scores = buildScoreArray(string, abbrev)

    # Faster than Array#inject...
    sum = 0.0
    scores.each { |x| sum += x }

    return sum / scores.length;
  end

  def self.buildScoreArray(string, abbrev)
    scores = Array.new(string.length)
    lower = string.downcase()

    lastIndex = 0
    started = false

    abbrev.downcase().each_char do |c|
      index = lower.index(c, lastIndex)
      return scores.fill(@@SCORE_NO_MATCH) if index.nil?
      started = true if index == 0

      if index > 0 and " ._-".include?(string[index - 1])
        scores[index - 1] = @@SCORE_MATCH
        scores.fill(@@SCORE_BUFFER, lastIndex...(index - 1))
      elsif string[index] >= ?A and string[index] <= ?Z
        scores.fill(@@SCORE_BUFFER, lastIndex...index)
      else
        scores.fill(@@SCORE_NO_MATCH, lastIndex...index)
      end

      scores[index] = @@SCORE_MATCH
      lastIndex = index + 1
    end

    trailing_score = started ? @@SCORE_TRAILING_BUT_STARTED : @@SCORE_TRAILING
    scores.fill(trailing_score, lastIndex)
    return scores
  end
end


# Used in FilesystemExplorer
module Lusty
class Entry
  attr_accessor :name, :current_score
  def initialize(name)
    @name = name
    @current_score = 0.0
  end
end
end

# Used in BufferExplorer
module Lusty
class BufferEntry < Entry
  attr_accessor :full_name, :vim_buffer
  def initialize(vim_buffer)
    @full_name = vim_buffer.name
    @vim_buffer = vim_buffer
    @name = "::UNSET::"
    @current_score = 0.0
  end
end
end


# Abstract base class; extended as BufferExplorer, FilesystemExplorer
module Lusty
class Explorer
  public
    def initialize
      @settings = SavedSettings.new
      @displayer = Displayer.new title()
      @prompt = nil
      @ordered_matching_entries = []
      @running = false
    end

    def run
      return if @running

      @settings.save
      @running = true
      @calling_window = $curwin
      @saved_alternate_bufnum = if VIM::evaluate_bool("expand('#') == ''")
                                  nil
                                else
                                  VIM::evaluate("bufnr(expand('#'))")
                                end
      @selected_index = 0
      create_explorer_window()
      refresh(:full)
    end

    def key_pressed()
      # Grab argument from the Vim function.
      i = VIM::evaluate("a:code_arg").to_i
      refresh_mode = :full

      case i
        when 32..126          # Printable characters
          c = i.chr
          @prompt.add! c
          @selected_index = 0
        when 8                # Backspace/Del/C-h
          @prompt.backspace!
          @selected_index = 0
        when 9, 13            # Tab and Enter
          choose(:current_tab)
          @selected_index = 0
        when 23               # C-w (delete 1 dir backward)
          @prompt.up_one_dir!
          @selected_index = 0
        when 14               # C-n (select next)
          @selected_index = \
            (@selected_index + 1) % @ordered_matching_entries.size
          refresh_mode = :no_recompute
        when 16               # C-p (select previous)
          @selected_index = \
            (@selected_index - 1) % @ordered_matching_entries.size
          refresh_mode = :no_recompute
        when 15               # C-o choose in new horizontal split
          choose(:new_split)
          @selected_index = 0
        when 20               # C-t choose in new tab
          choose(:new_tab)
          @selected_index = 0
        when 21               # C-u clear prompt
          @prompt.clear!
          @selected_index = 0
        when 22               # C-v choose in new vertical split
          choose(:new_vsplit)
          @selected_index = 0
      end

      refresh(refresh_mode)
    end

    def cancel
      if @running
        cleanup()
        # fix alternate file
        if @saved_alternate_bufnum
          cur = $curbuf
          VIM::command "silent b #{@saved_alternate_bufnum}"
          VIM::command "silent b #{cur.number}"
        end

        if $LUSTY_PROFILING
          outfile = File.new('rbprof.html', 'a')
          #RubyProf::CallTreePrinter.new(RubyProf.stop).print(outfile)
          RubyProf::GraphHtmlPrinter.new(RubyProf.stop).print(outfile)
        end
      end
    end

  private
    def refresh(mode)
      return if not @running

      if mode == :full
        @ordered_matching_entries = compute_ordered_matching_entries()
      end

      on_refresh()
      highlight_selected_index()
      @displayer.print @ordered_matching_entries.map { |x| x.name }
      @prompt.print
    end

    def create_explorer_window

      @displayer.create

      # Setup key mappings to reroute user input.

      # Non-special printable characters.
      printables =  '/!"#$%&\'()*+,-.0123456789:<=>?#@"' \
                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ' \
                    '[]^_`abcdefghijklmnopqrstuvwxyz{}~'

      map = "noremap <silent> <buffer>"
      name = self.class.to_s.sub(/.*::/,'')  # Trim out "Lusty::"

      printables.each_byte do |b|
        VIM::command "#{map} <Char-#{b}> :call <SID>Lusty#{name}KeyPressed(#{b})<CR>"
      end

      # Special characters
      VIM::command "#{map} <Tab>    :call <SID>Lusty#{name}KeyPressed(9)<CR>"
      VIM::command "#{map} <Bslash> :call <SID>Lusty#{name}KeyPressed(92)<CR>"
      VIM::command "#{map} <Space>  :call <SID>Lusty#{name}KeyPressed(32)<CR>"
      VIM::command "#{map} \026|    :call <SID>Lusty#{name}KeyPressed(124)<CR>"

      VIM::command "#{map} <BS>     :call <SID>Lusty#{name}KeyPressed(8)<CR>"
      VIM::command "#{map} <Del>    :call <SID>Lusty#{name}KeyPressed(8)<CR>"
      VIM::command "#{map} <C-h>    :call <SID>Lusty#{name}KeyPressed(8)<CR>"

      VIM::command "#{map} <CR>     :call <SID>Lusty#{name}KeyPressed(13)<CR>"
      VIM::command "#{map} <S-CR>   :call <SID>Lusty#{name}KeyPressed(10)<CR>"
      VIM::command "#{map} <C-a>    :call <SID>Lusty#{name}KeyPressed(1)<CR>"

      VIM::command "#{map} <Esc>    :call <SID>Lusty#{name}Cancel()<CR>"
      VIM::command "#{map} <C-c>    :call <SID>Lusty#{name}Cancel()<CR>"
      VIM::command "#{map} <C-g>    :call <SID>Lusty#{name}Cancel()<CR>"

      VIM::command "#{map} <C-w>    :call <SID>Lusty#{name}KeyPressed(23)<CR>"
      VIM::command "#{map} <C-n>    :call <SID>Lusty#{name}KeyPressed(14)<CR>"
      VIM::command "#{map} <C-p>    :call <SID>Lusty#{name}KeyPressed(16)<CR>"
      VIM::command "#{map} <C-o>    :call <SID>Lusty#{name}KeyPressed(15)<CR>"
      VIM::command "#{map} <C-t>    :call <SID>Lusty#{name}KeyPressed(20)<CR>"
      VIM::command "#{map} <C-v>    :call <SID>Lusty#{name}KeyPressed(22)<CR>"
      VIM::command "#{map} <C-e>    :call <SID>Lusty#{name}KeyPressed(5)<CR>"
      VIM::command "#{map} <C-r>    :call <SID>Lusty#{name}KeyPressed(18)<CR>"
      VIM::command "#{map} <C-u>    :call <SID>Lusty#{name}KeyPressed(21)<CR>"
    end

    def highlight_selected_index
      return unless VIM::has_syntax?

      entry = @ordered_matching_entries[@selected_index]
      return if entry.nil?

      VIM::command "syn clear LustyExpSelected"
      VIM::command "syn match LustyExpSelected " \
	           "\"#{Displayer.vim_match_string(entry.name, false)}\" "
    end

    def compute_ordered_matching_entries
      abbrev = current_abbreviation()
      unordered = matching_entries()

      # Sort alphabetically if there's just a dot or we have no abbreviation,
      # otherwise it just looks weird.
      if abbrev.length == 0 or abbrev == '.'
        unordered.sort! { |x, y| x.name <=> y.name }
      else
        # Sort by score.
        unordered.sort! { |x, y| y.current_score <=> x.current_score }
      end
    end

    def matching_entries
      abbrev = current_abbreviation()
      all_entries().select { |x|
        x.current_score = LiquidMetal.score(x.name, abbrev)
        x.current_score != 0.0
      }
    end

    def choose(open_mode)
      entry = @ordered_matching_entries[@selected_index]
      return if entry.nil?
      @selected_index = 0
      open_entry(entry, open_mode)
    end

    def cleanup
      @displayer.close
      Window.select @calling_window
      @settings.restore
      @running = false
      VIM::message ""
      Lusty::assert(@calling_window == $curwin)
    end
end
end


module Lusty
class BufferExplorer < Explorer
  public
    def initialize
      super
      @prompt = Prompt.new
      @buffer_entries = []
    end

    def run
      unless @running
        @prompt.clear!
        @curbuf_at_start = VIM::Buffer.current
        @buffer_entries = compute_buffer_entries()
        super
      end
    end

  private
    def title
      '[LustyExplorer-Buffers]'
    end

    def curbuf_match_string
      curbuf = @buffer_entries.find { |x| x.vim_buffer == @curbuf_at_start }
      if curbuf
        Displayer.vim_match_string(curbuf.name, @prompt.insensitive?)
      else
        ""
      end
    end

    def on_refresh
      # Highlighting for the current buffer name.
      if VIM::has_syntax?
        VIM::command 'syn clear LustyExpCurrentBuffer'
        VIM::command 'syn match LustyExpCurrentBuffer ' \
                     "\"#{curbuf_match_string()}\" " \
                     'contains=LustyExpModified'
      end
    end

    def common_prefix(entries)
      prefix = entries[0].full_name
      entries.each do |entry|
        full_name = entry.full_name
        for i in 0...prefix.length
          if full_name.length <= i or prefix[i] != full_name[i]
            prefix = prefix[0...i]
            prefix = prefix[0..(prefix.rindex('/') or -1)]
            break
          end
        end
      end
      return prefix
    end

    def compute_buffer_entries
      buffer_entries = []
      (0..VIM::Buffer.count-1).each do |i|
        buffer_entries << BufferEntry.new(VIM::Buffer[i])
      end

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
          basename_to_prefix[base] = common_prefix(entries)
        end
      end

      # Compute shortened buffer names by removing prefix, if possible.
      buffer_entries.each do |entry|
        full_name = entry.full_name

        short_name = if full_name.nil?
                       '[No Name]'
                     elsif Lusty::starts_with?(full_name, "scp://")
                       full_name
                     else
                       base = Pathname.new(full_name).basename.to_s
                       prefix = basename_to_prefix[base]

                       prefix ? full_name[prefix.length..-1] \
                              : base
                     end

        # Disabled: show buffer number next to name
        #short_name << ' ' + buffer.number.to_s

        # Show modification indicator
        short_name << (entry.vim_buffer.modified? ? " [+]" : "")

        entry.name = short_name
      end

      buffer_entries
    end

    def current_abbreviation
      @prompt.input
    end

    def all_entries
      @buffer_entries
    end

    def open_entry(entry, open_mode)
      cleanup()
      Lusty::assert($curwin == @calling_window)

      number = entry.vim_buffer.number
      Lusty::assert(number)

      cmd = case open_mode
            when :current_tab
              "b"
            when :new_tab
              # For some reason just using tabe or e gives an error when
              # the alternate-file isn't set.
              "tab split | b"
            when :new_split
	      "sp | b"
            when :new_vsplit
	      "vs | b"
            else
              Lusty::assert(false, "bad open mode")
            end

      VIM::command "silent #{cmd} #{number}"
    end
end
end


module Lusty
class FilesystemExplorer < Explorer
  public
    def initialize
      super
      @prompt = FilesystemPrompt.new
      @memoized_entries = {}
    end

    def run
      FileMasks.create_glob_masks()
      @vim_swaps = VimSwaps.new
      super
    end

    def run_from_here
      start_path = if $curbuf.name.nil?
                     VIM::getcwd()
                   else
                     VIM::evaluate("expand('%:p:h')")
                   end

      @prompt.set!(start_path + File::SEPARATOR)
      run()
    end

    def run_from_wd
      @prompt.set!(VIM::getcwd() + File::SEPARATOR)
      run()
    end

    def key_pressed()
      i = VIM::evaluate("a:code_arg").to_i

      case i
      when 1, 10  # <C-a>, <Shift-Enter>
        cleanup()
        # Open all non-directories currently in view.
        @ordered_matching_entries.each do |e|
          path_str = \
            if @prompt.at_dir?
              @prompt.input + e.name
            else
              @prompt.dirname + File::SEPARATOR + e.name
            end

          load_file(path_str, :current_tab) unless File.directory?(path_str)
        end
      when 5      # <C-e> edit file, create it if necessary
        if not @prompt.at_dir?
          cleanup()
          # Force a reread of this directory so that the new file will
          # show up (as long as it is saved before the next run).
          @memoized_entries.delete(view_path())
          load_file(@prompt.input, :current_tab)
        end
      when 18     # <C-r> refresh
        @memoized_entries.delete(view_path())
        refresh(:full)
      else
        super
      end
    end

  private
    def title
    '[LustyExplorer-Files]'
    end

    def on_refresh
      if VIM::has_syntax?
        VIM::command 'syn clear LustyExpFileWithSwap'

        view = view_path()
        @vim_swaps.file_names.each do |file_with_swap|
          if file_with_swap.dirname == view
            base = file_with_swap.basename
            match_str = Displayer.vim_match_string(base.to_s, false)
            VIM::command "syn match LustyExpFileWithSwap \"#{match_str}\""
          end
        end
      end

      # TODO: restore highlighting for open buffers?
    end

    def current_abbreviation
      if @prompt.at_dir?
        ""
      else
        File.basename(@prompt.input)
      end
    end

    def view_path
      input = @prompt.input

      path = \
        if @prompt.at_dir? and \
           input.length > 1         # Not root
          # The last element in the path is a directory + '/' and we want to
          # see what's in it instead of what's in its parent directory.

          Pathname.new(input[0..-2])  # Canonicalize by removing trailing '/'
        else
          Pathname.new(input).dirname
        end

      return path
    end

    def all_entries
      view = view_path()

      unless @memoized_entries.has_key?(view)

        if not view.directory?
          return []
        elsif not view.readable?
          # TODO: show "-- PERMISSION DENIED --"
          return []
        end

        # Generate an array of the files
        entries = []
        view_str = view.to_s
        unless Lusty::ends_with?(view_str, File::SEPARATOR)
          # Don't double-up on '/' -- makes Cygwin sad.
          view_str << File::SEPARATOR
        end

        Dir.foreach(view_str) do |name|
          next if name == "."   # Skip pwd
          next if name == ".." and Lusty::option_set?("AlwaysShowDotFiles")

          # Hide masked files.
          next if FileMasks.masked?(name)

          if FileTest.directory?(view_str + name)
            name << File::SEPARATOR
          end
          entries << Entry.new(name)
        end
        @memoized_entries[view] = entries
      end

      all = @memoized_entries[view]

      if Lusty::option_set?("AlwaysShowDotFiles") or \
         current_abbreviation()[0] == ?.
        all
      else
        # Filter out dotfiles if the current abbreviation doesn't start with
        # '.'.
        all.select { |x| x.name[0] != ?. }
      end
    end

    def open_entry(entry, open_mode)
      path = view_path() + entry.name

      if File.directory?(path)
        # Recurse into the directory instead of opening it.
        @prompt.set!(path.to_s)
      elsif entry.name.include?(File::SEPARATOR)
        # Don't open a fake file/buffer with "/" in its name.
        return
      else
        cleanup()
        load_file(path.to_s, open_mode)
      end
    end

    def load_file(path_str, open_mode)
      Lusty::assert($curwin == @calling_window)
      # Escape for Vim and remove leading ./ for files in pwd.
      filename_escaped = VIM::filename_escape(path_str).sub(/^\.\//,"")
      single_quote_escaped = VIM::single_quote_escape(filename_escaped)
      sanitized = VIM::evaluate "fnamemodify('#{single_quote_escaped}', ':.')"
      cmd = case open_mode
            when :current_tab
              "e"
            when :new_tab
              "tabe"
            when :new_split
	      "sp"
            when :new_vsplit
	      "vs"
            else
              Lusty::assert(false, "bad open mode")
            end

      VIM::command "silent #{cmd} #{sanitized}"
    end
end
end


module Lusty

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

    def print
      VIM::pretty_msg("Comment", @@PROMPT,
                      "None", VIM::single_quote_escape(@input),
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
      Lusty::ends_with?(@input, c)
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
      @memoized = Lusty::simplify_path(variable_expansion(@input))
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


# Simplify switching between windows.
module Lusty
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


# Save and restore settings when creating the explorer buffer.
module Lusty
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

    @report = VIM::evaluate("&report")
    @sidescroll = VIM::evaluate("&sidescroll")
    @sidescrolloff = VIM::evaluate("&sidescrolloff")
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

    VIM::command "set report=#{@report}"
    VIM::command "set sidescroll=#{@sidescroll}"
    VIM::command "set sidescrolloff=#{@sidescrolloff}"
  end
end
end


# Manage the explorer buffer.
module Lusty
class Displayer
  private
    @@COLUMN_SEPARATOR = "    "
    @@NO_MATCHES_STRING = "-- NO MATCHES --"
    @@TRUNCATED_STRING = "-- TRUNCATED --"

  public
    def self.vim_match_string(s, case_insensitive)
      # Create a match regex string for the given s.  This is for a Vim regex,
      # not for a Ruby regex.

      str = '\%(^\|' + @@COLUMN_SEPARATOR + '\)' \
            '\zs' + VIM::regex_escape(s) + '\%( \[+\]\)\?' + '\ze' \
            '\%(\s*$\|' + @@COLUMN_SEPARATOR + '\)'

      str << '\c' if case_insensitive

      return str
    end

    def initialize(title)
      @title = title
      @window = nil
      @buffer = nil

      # Hashes by range, e.g. 0..2, representing the width
      # of the column bounded by that range.
      @col_range_widths = {}
    end

    def create
      # Make a window for the displayer and move there.
      # Start at size 1 to mitigate flashing effect when
      # we resize the window later.
      VIM::command "silent! botright 1split #{@title}"

      @window = $curwin
      @buffer = $curbuf

      # Displayer buffer is special.
      VIM::command "setlocal bufhidden=delete"
      VIM::command "setlocal buftype=nofile"
      VIM::command "setlocal nomodifiable"
      VIM::command "setlocal noswapfile"
      VIM::command "setlocal nowrap"
      VIM::command "setlocal nonumber"
      VIM::command "setlocal foldcolumn=0"
      VIM::command "setlocal nocursorline"
      VIM::command "setlocal nospell"
      VIM::command "setlocal nobuflisted"
      VIM::command "setlocal textwidth=0"
      VIM::command "setlocal noreadonly"

      # (Update SavedSettings if adding to below.)
      VIM::set_option "timeoutlen=0"
      VIM::set_option "noinsertmode"
      VIM::set_option "noshowcmd"
      VIM::set_option "nolist"
      VIM::set_option "report=9999"
      VIM::set_option "sidescroll=0"
      VIM::set_option "sidescrolloff=0"

      # TODO -- cpoptions?

      if VIM::has_syntax?
        VIM::command 'syn match LustyExpSlash "/" contained'
        VIM::command 'syn match LustyExpDir "\zs\%(\S\+ \)*\S\+/\ze" ' \
                                            'contains=LustyExpSlash'

        VIM::command 'syn match LustyExpModified " \[+\]"'

        VIM::command 'syn match LustyExpNoEntries "\%^\s*' \
                                                  "#{@@NO_MATCHES_STRING}" \
                                                  '\s*\%$"'

        VIM::command 'syn match LustyExpTruncated "^\s*' \
                                                  "#{@@TRUNCATED_STRING}" \
                                                  '\s*$"'

        VIM::command 'highlight link LustyExpDir Directory'
        VIM::command 'highlight link LustyExpSlash Function'
        VIM::command 'highlight link LustyExpSelected Type'
        VIM::command 'highlight link LustyExpModified Special'
        VIM::command 'highlight link LustyExpCurrentBuffer Constant'
        VIM::command 'highlight link LustyExpOpenedFile PreProc'
        VIM::command 'highlight link LustyExpFileWithSwap WarningMsg'
        VIM::command 'highlight link LustyExpNoEntries ErrorMsg'
        VIM::command 'highlight link LustyExpTruncated Visual'
      end
    end

    def print(strings)
      Window.select(@window) || return

      if strings.empty?
        print_no_entries()
        return
      end

      row_count, col_count, col_widths, truncated = \
        compute_optimal_layout(strings)

      # Slice the strings into rows.
      rows = Array.new(row_count){[]}
      col_index = 0
      strings.each_slice(row_count) do |column|
        column_width = col_widths[col_index]
        column.each_index do |i|
          string = column[i]

          rows[i] << string

          if col_index < col_count - 1
            # Add spacer to the width of the column
            rows[i] << (" " * (column_width - string.length))
            rows[i] << @@COLUMN_SEPARATOR
          end
        end

        col_index += 1
        break if col_index >= col_count
      end

      print_rows(rows, truncated)
    end

    def close
      # Only wipe the buffer if we're *sure* it's the explorer.
      if Window.select @window and \
         $curbuf == @buffer and \
         $curbuf.name =~ /#{Regexp.escape(@title)}$/
          VIM::command "bwipeout!"
          @window = nil
          @buffer = nil
      end
    end

    def self.max_height
      stored_height = $curwin.height
      $curwin.height = VIM::MOST_POSITIVE_INTEGER
      highest_allowable = $curwin.height
      $curwin.height = stored_height
      highest_allowable
    end

    def self.max_width
      VIM::columns()
    end

  private

    def compute_optimal_layout(strings)
      # Compute optimal row count and corresponding column count.
      # The displayer attempts to fit `strings' on as few rows as
      # possible.

      max_width = Displayer.max_width()
      displayable_string_upper_bound = compute_displayable_upper_bound(strings)

      # Determine optimal row count.
      optimal_row_count, truncated = \
        if strings.length > displayable_string_upper_bound
          # Use all available rows and truncate results.
          # The -1 is for the truncation indicator.
          [Displayer.max_height - 1, true]
        else
          single_row_width = \
            strings.inject(0) { |len, s|
              len + @@COLUMN_SEPARATOR.length + s.length
            }
          if single_row_width <= max_width
            # All fits on a single row
            [1, false]
          else
            compute_optimal_row_count(strings)
          end
        end

      # Compute column_count and column_widths.
      column_count = 0
      column_widths = []
      total_width = 0
      strings.each_slice(optimal_row_count) do |column|
        column_width = column.max { |a, b| a.length <=> b.length }.length
        total_width += column_width

        break if total_width > max_width

        column_count += 1
        column_widths << column_width
        total_width += @@COLUMN_SEPARATOR.length
      end

      [optimal_row_count, column_count, column_widths, truncated]
    end

    def print_rows(rows, truncated)
      unlock_and_clear()

      # Grow/shrink the window as needed
      $curwin.height = rows.length + (truncated ? 1 : 0)

      # Print the rows.
      rows.each_index do |i|
        $curwin.cursor = [i+1, 1]
        $curbuf.append(i, rows[i].join(''))
      end

      # Print a TRUNCATED indicator, if needed.
      if truncated
        $curbuf.append($curbuf.count - 1, \
                       @@TRUNCATED_STRING.center($curwin.width, " "))
      end

      # Stretch the last line to the length of the window with whitespace so
      # that we can "hide" the cursor in the corner.
      last_line = $curbuf[$curbuf.count - 1]
      last_line << (" " * ($curwin.width - last_line.length))
      $curbuf[$curbuf.count - 1] = last_line

      # There's a blank line at the end of the buffer because of how
      # VIM::Buffer.append works.
      $curbuf.delete $curbuf.count
      lock()
    end

    def print_no_entries
      unlock_and_clear()
      $curwin.height = 1
      $curbuf[1] = @@NO_MATCHES_STRING.center($curwin.width, " ")
      lock()
    end

    def unlock_and_clear
      VIM::command "setlocal modifiable"

      # Clear the explorer (black hole register)
      VIM::command "silent %d _"
    end

    def lock
      VIM::command "setlocal nomodifiable"

      # Hide the cursor
      VIM::command "normal! Gg$"
    end

    def compute_displayable_upper_bound(strings)
      # Compute an upper-bound on the number of displayable matches.
      # Basically: find the length of the longest string, then keep
      # adding shortest strings until we pass the width of the Vim
      # window.  This is the maximum possible column-count assuming
      # all strings can fit.  Then multiply by the number of rows.

      sorted_by_shortest = strings.sort { |x, y| x.length <=> y.length }
      longest_length = sorted_by_shortest.pop.length

      row_width = longest_length + @@COLUMN_SEPARATOR.length

      max_width = Displayer.max_width()
      column_count = 1

      sorted_by_shortest.each do |str|
        row_width += str.length
        if row_width > max_width
          break
        end

        column_count += 1
        row_width += @@COLUMN_SEPARATOR.length
      end

      column_count * Displayer.max_height()
    end

    def compute_optimal_row_count(strings)
      max_width = Displayer.max_width
      max_height = Displayer.max_height

      # Creating a new hash is faster than clearing the old one.
      @col_range_widths = {}

      # Binary search; find the lowest number of rows at which we
      # can fit all the strings.

      # We've already failed for a single row, so start at two.
      lower = 1  # (1 = 2 - 1)
      upper = max_height + 1
      while lower + 1 != upper
        row_count = (lower + upper) / 2   # Mid-point

        col_start_index = 0
        col_end_index = row_count - 1
        total_width = 0

        while col_end_index < strings.length
          total_width += \
            compute_column_width(col_start_index..col_end_index, strings)

          if total_width > max_width
            # Early exit.
            total_width = Lusty::MOST_POSITIVE_FIXNUM
            break
          end

          total_width += @@COLUMN_SEPARATOR.length

          col_start_index += row_count
          col_end_index += row_count

          if col_end_index >= strings.length and \
             col_start_index < strings.length
            # Remainder; last iteration will not be a full column.
            col_end_index = strings.length - 1
          end
        end

        # The final column doesn't need a separator.
        total_width -= @@COLUMN_SEPARATOR.length

        if total_width <= max_width
          # This row count fits.
          upper = row_count
        else
          # This row count doesn't fit.
          lower = row_count
        end
      end

      if upper > max_height
        # No row count can accomodate all strings; have to truncate.
        # (-1 for the truncate indicator)
        [max_height - 1, true]
      else
        [upper, false]
      end
    end

    def compute_column_width(range, strings)

      if (range.first == range.last)
        return strings[range.first].length
      end

      width = @col_range_widths[range]

      if width.nil?
        # Recurse for each half of the range.
        split_point = range.first + ((range.last - range.first) >> 1)

        first_half = compute_column_width(range.first..split_point, strings)
        second_half = compute_column_width(split_point+1..range.last, strings)

        width = [first_half, second_half].max
        @col_range_widths[range] = width
      end

      width
    end
end
end


module Lusty
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
      # STEVE create a single regex instead of looping
      @@glob_masks.each do |mask|
        return true if File.fnmatch(mask, str)
      end

      return false
    end
end
end


module Lusty
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
      if Lusty::ready_for_read?(@vim_r)
        @files_with_swaps = []
        @vim_r.each_line do |line|
          if line =~ /^ +file name: (.*)$/
            file = $1.chomp
            @files_with_swaps << Pathname.new(Lusty::simplify_path(file))
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



$lusty_buffer_explorer = Lusty::BufferExplorer.new
$lusty_filesystem_explorer = Lusty::FilesystemExplorer.new

EOF

" vim: set sts=2 sw=2:
