# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

# Abstract base class; extended as BufferExplorer, FilesystemExplorer
module LustyM
class Explorer
  public
    def initialize
      @settings = SavedSettings.new
      @display = Display.new title()
      @prompt = nil
      @current_sorted_matches = []
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
        when 23               # C-w (delete 1 dir backward)
          @prompt.up_one_dir!
          @selected_index = 0
        when 14               # C-n (select next)
          @selected_index = \
            if @current_sorted_matches.size.zero?
              0
            else
              (@selected_index + 1) % @current_sorted_matches.size
            end
          refresh_mode = :no_recompute
        when 16               # C-p (select previous)
          @selected_index = \
            if @current_sorted_matches.size.zero?
              0
            else
              (@selected_index - 1) % @current_sorted_matches.size
            end
          refresh_mode = :no_recompute
        when 6                # C-f (select right)
          @selected_index = \
            if @row_count.nil? || @row_count.zero?
              0
            else
              columns = \
                (@current_sorted_matches.size.to_f / @row_count.to_f).ceil
              cur_column = @selected_index / @row_count
              cur_row = @selected_index % @row_count
              new_column = (cur_column + 1) % columns
              if (new_column + 1) * (cur_row + 1) > @current_sorted_matches.size
                new_column = 0
              end
              new_column * @row_count + cur_row
            end
          refresh_mode = :no_recompute
        when 2                # C-b (select left)
          @selected_index = \
            if @row_count.nil? || @row_count.zero?
              0
            else
              columns = \
                (@current_sorted_matches.size.to_f / @row_count.to_f).ceil
              cur_column = @selected_index / @row_count
              cur_row = @selected_index % @row_count
              new_column = (cur_column - 1) % columns
              if (new_column + 1) * (cur_row + 1) > @current_sorted_matches.size
                new_column = columns - 2
              end
              new_column * @row_count + cur_row
            end
          refresh_mode = :no_recompute
        when 15               # C-o choose in new horizontal split
          choose(:new_split)
        when 20               # C-t choose in new tab
          choose(:new_tab)
        when 21               # C-u clear prompt
          @prompt.clear!
          @selected_index = 0
        when 22               # C-v choose in new vertical split
          choose(:new_vsplit)
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
          outfile = File.new('lusty-explorer-rbprof.html', 'a')
          #RubyProf::CallTreePrinter.new(RubyProf.stop).print(outfile)
          RubyProf::GraphHtmlPrinter.new(RubyProf.stop).print(outfile)
        end
      end
    end

  private
    def refresh(mode)
      return if not @running

      if mode == :full
        @current_sorted_matches = compute_sorted_matches()
      end

      on_refresh()
      highlight_selected_index() if VIM::has_syntax?
      @row_count = @display.print @current_sorted_matches.map { |x| x.label }
      @prompt.print Display.max_width
    end

    def create_explorer_window
      # Trim out the "::" in "LustyM::FooExplorer"
      key_binding_prefix = 'Lusty' + self.class.to_s.sub(/.*::/,'')

      @display.create(key_binding_prefix)
      set_syntax_matching()
    end

    def highlight_selected_index
      # Note: overridden by BufferGrep
      VIM::command 'syn clear LustySelected'

      entry = @current_sorted_matches[@selected_index]
      return if entry.nil?

      escaped = VIM::regex_escape(entry.label)
      label_match_string = Display.entry_syntaxify(escaped, false)
      VIM::command "syn match LustySelected \"#{label_match_string}\" " \
                                            'contains=LustyGrepMatch'
    end

    def choose(open_mode)
      entry = @current_sorted_matches[@selected_index]
      return if entry.nil?
      open_entry(entry, open_mode)
    end

    def cleanup
      @display.close
      Window.select @calling_window
      @settings.restore
      @running = false
      VIM::message ""
      LustyM::assert(@calling_window == $curwin)
    end

    # Pure virtual methods
    # - set_syntax_matching
    # - on_refresh
    # - open_entry
    # - compute_sorted_matches

end
end

