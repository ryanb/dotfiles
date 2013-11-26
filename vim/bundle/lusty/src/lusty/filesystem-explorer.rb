# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

module LustyM
class FilesystemExplorer < Explorer
  public
    def initialize
      super
      @prompt = FilesystemPrompt.new
      @memoized_dir_contents = {}
    end

    def run
      return if @running

      FileMasks.create_glob_masks()
      @vim_swaps = VimSwaps.new
      @selected_index = 0
      super
    end

    def run_from_path(path)
      return if @running
      if path.empty?
        path = VIM::getcwd()
      end
      if path.respond_to?(:force_encoding)
        path = path.force_encoding(VIM::evaluate('&enc'))
      end
      @prompt.set!(path + File::SEPARATOR)
      run()
    end

    def key_pressed()
      i = VIM::evaluate("a:code_arg").to_i

      case i
      when 1, 10  # <C-a>, <Shift-Enter>
        cleanup()
        # Open all non-directories currently in view.
        @current_sorted_matches.each do |e|
          path_str = \
            if @prompt.at_dir?
              @prompt.input + e.label
            else
              dir = @prompt.dirname
              if dir == '/'
                dir + e.label
              else
                dir + File::SEPARATOR + e.label
              end
            end

          load_file(path_str, :current_tab) unless File.directory?(path_str)
        end
      when 5      # <C-e> edit file, create it if necessary
        if not @prompt.at_dir?
          cleanup()
          # Force a reread of this directory so that the new file will
          # show up (as long as it is saved before the next run).
          @memoized_dir_contents.delete(view_path())
          load_file(@prompt.input, :current_tab)
        end
      when 18     # <C-r> refresh
        @memoized_dir_contents.delete(view_path())
        refresh(:full)
      else
        super
      end
    end

  private
    def title
      'LustyExplorer--Files'
    end

    def set_syntax_matching
      # Base highlighting -- more is set on refresh.
      if VIM::has_syntax?
        VIM::command 'syn match LustySlash "/" contained'
        VIM::command 'syn match LustyDir "\%(\S\+ \)*\S\+/" ' \
                                         'contains=LustySlash'
      end
    end

    def on_refresh
      if VIM::has_syntax?
        VIM::command 'syn clear LustyFileWithSwap'

        view = view_path()
        @vim_swaps.file_names.each do |file_with_swap|
          if file_with_swap.dirname == view
            base = file_with_swap.basename
            escaped = VIM::regex_escape(base.to_s)
            match_str = Display.entry_syntaxify(escaped, false)
            VIM::command "syn match LustyFileWithSwap \"#{match_str}\""
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

    def all_files_at_view
      view = view_path()

      unless @memoized_dir_contents.has_key?(view)

        if not view.directory?
          return []
        elsif not view.readable?
          # TODO: show "-- PERMISSION DENIED --"
          return []
        end

        # Generate an array of the files
        entries = []
        view_str = view.to_s
        unless LustyM::ends_with?(view_str, File::SEPARATOR)
          # Don't double-up on '/' -- makes Cygwin sad.
          view_str << File::SEPARATOR
        end

        begin
          Dir.foreach(view_str) do |name|
            next if name == "."   # Skip pwd
            next if name == ".." and LustyM::option_set?("AlwaysShowDotFiles")

            # Hide masked files.
            next if FileMasks.masked?(name)

            if FileTest.directory?(view_str + name)
              name << File::SEPARATOR
            end
            entries << FilesystemEntry.new(name)
          end
        rescue Errno::EACCES
          # TODO: show "-- PERMISSION DENIED --"
          return []
        end
        @memoized_dir_contents[view] = entries
      end

      all = @memoized_dir_contents[view]

      if LustyM::option_set?("AlwaysShowDotFiles") or \
         current_abbreviation()[0] == ?.
        all
      else
        # Filter out dotfiles if the current abbreviation doesn't start with
        # '.'.
        all.select { |x| x.label[0] != ?. }
      end
    end

    def compute_sorted_matches
      abbrev = current_abbreviation()

      unsorted = all_files_at_view()

      if abbrev.length == 0
        # Sort alphabetically if we have no abbreviation.
        unsorted.sort { |x, y| x.label <=> y.label }
      else
        matches = \
          unsorted.select { |x|
            x.current_score = Mercury.score(x.label, abbrev)
            x.current_score != 0.0
          }

        if abbrev == '.'
          # Sort alphabetically, otherwise it just looks weird.
          matches.sort! { |x, y| x.label <=> y.label }
        else
          # Sort by score.
          matches.sort! { |x, y| y.current_score <=> x.current_score }
        end
      end
    end

    def open_entry(entry, open_mode)
      path = view_path() + entry.label

      if File.directory?(path.to_s)
        # Recurse into the directory instead of opening it.
        @prompt.set!(path.to_s)
        @selected_index = 0
      elsif entry.label.include?(File::SEPARATOR)
        # Don't open a fake file/buffer with "/" in its name.
        return
      else
        cleanup()
        load_file(path.to_s, open_mode)
      end
    end

    def load_file(path_str, open_mode)
      LustyM::assert($curwin == @calling_window)
      filename_escaped = VIM::filename_escape(path_str)
      # Escape single quotes again since we may have just left ruby for Vim.
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
              LustyM::assert(false, "bad open mode")
            end

      VIM::command "silent #{cmd} #{sanitized}"
    end
end
end

