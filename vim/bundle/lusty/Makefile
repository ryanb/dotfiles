# Copyright (C) 2007 Stephen Bach
#
# Permission is hereby granted to use and distribute this code, with or without
# modifications, provided that this copyright notice is copied with it. Like
# anything else that's free, this file is provided *as is* and comes with no
# warranty of any kind, either expressed or implied. In no event will the
# copyright holder be liable for any damages resulting from the use of this
# software.

EXPLORER_VIM_FILE = src/explorer.vim

# Order matters.
EXPLORER_RUBY_FILES = src/vim.rb \
                      src/lusty.rb \
                      src/mercury.rb \
                      src/lusty/entry.rb \
                      src/lusty/explorer.rb \
                      src/lusty/buffer-explorer.rb \
                      src/lusty/filesystem-explorer.rb \
                      src/lusty/buffer-grep.rb \
                      src/lusty/prompt.rb \
                      src/lusty/window.rb \
                      src/lusty/saved-settings.rb \
                      src/lusty/display.rb \
                      src/lusty/file-masks.rb \
                      src/lusty/vim-swaps.rb \
                      src/lusty/buffer-stack.rb

JUGGLER_VIM_FILE = src/juggler.vim

# Order matters.
JUGGLER_RUBY_FILES = src/vim.rb \
		     src/lusty.rb \
		     src/lusty/juggler.rb \
		     src/lusty/bar-item.rb \
		     src/lusty/name-bar.rb \
		     src/lusty/buffer-stack.rb

all: plugin/lusty-explorer.vim plugin/lusty-juggler.vim

UNAME := $(shell uname)

# OS X's sed doesn't have \< or \b for word boundaries.
ifeq ($(UNAME), Darwin)
LEFT_BOUND = [[:<:]]
RIGHT_BOUND = [[:>:]]
else
LEFT_BOUND = \<
RIGHT_BOUND = \>
endif

# Concatenate the Ruby files, removing redundant copyrights, and insert
# the results into the vimscript files.  Change LustyM module references to
# LustyE or LustyJ, so that using out-of-sync versions of lusty-explorer and
# lusty-juggler is less likely to cause monkey patching issues.

plugin/lusty-explorer.vim: $(EXPLORER_VIM_FILE) $(EXPLORER_RUBY_FILES)
	for file in $(EXPLORER_RUBY_FILES); do \
	  cat $$file | sed '1,/^$$/d' ;\
	  echo ; \
	done | sed 's/$(LEFT_BOUND)LustyM$(RIGHT_BOUND)/LustyE/g' > \
	ruby-content.tmp
	( sed '/{{RUBY_CODE_INSERTION_POINT}}/,$$d' $(EXPLORER_VIM_FILE) ; \
	  cat ruby-content.tmp ; \
	  sed '1,/{{RUBY_CODE_INSERTION_POINT}}/d' $(EXPLORER_VIM_FILE) ) > \
	plugin/lusty-explorer.vim
	rm -f ruby-content.tmp

plugin/lusty-juggler.vim: $(JUGGLER_VIM_FILE) $(JUGGLER_RUBY_FILES)
	for file in $(JUGGLER_RUBY_FILES); do \
	  cat $$file | sed '1,/^$$/d' ;\
	  echo ; \
	done | sed 's/$(LEFT_BOUND)LustyM$(RIGHT_BOUND)/LustyJ/g' > \
	ruby-content.tmp
	( sed '/{{RUBY_CODE_INSERTION_POINT}}/,$$d' $(JUGGLER_VIM_FILE) ; \
	  cat ruby-content.tmp ; \
	  sed '1,/{{RUBY_CODE_INSERTION_POINT}}/d' $(JUGGLER_VIM_FILE) ) > \
	plugin/lusty-juggler.vim
	rm -f ruby-content.tmp
clean:
	rm -f ruby-content.tmp plugin/lusty-explorer.vim \
              plugin/lusty-juggler.vim

