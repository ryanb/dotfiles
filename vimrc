" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load pathogen for managing all those pesky plugins.
" Load this first so ftdetect in bundles works properly.
call pathogen#runtime_append_all_bundles() 

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

syntax on		" enable syntax highlighting
set history=50		" keep 50 lines of command line history
set laststatus=1        " only show the status line for multiple windows
set ruler               " show cursor position
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch		" highlight search results
set mouse=a		" enable the mouse
set expandtab		" always use spaces not tabs
set ts=8 sw=8 sts=8     " default to 8 space tabs
set autoindent nosmartindent nocindent  " go for simple autoindenting
set nofoldenable        " disable code folding
set hidden              " unload any buffer that's hidden

" Put swap files in /tmp, and don't keep backups.
set dir=/tmp
set nobackup

" Stop Lusty Juggler complaining when we use the system vim.
let g:LustyJugglerSuppressRubyWarning = 1

" Show relative paths in bufexplorer.
let g:bufExplorerShowRelativePath=1
" Hide the default help in bufexplorer.
let g:bufExplorerDefaultHelp=0

" Open buffer explorer on F1.
" (F1 key normally opens help. Killing this is good.)
map <F1> \be
" Open lusty explorer on F2.
map <F2> \lf
" Open lusty explorer in the current file's directory on F3.
map <F3> \lr
" Use CTRL-H and CTRL-L to skip forward and back through functions.
map <C-L> ]m
map <C-H> [m
" Use CTRL-A to re-align ruby, SQL, and cucumber.
map <C-A> !align-ruby<CR>

" Don't use Ex mode, use Q for formatting.
map Q gq
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Enable file type detection, but disable smart indenting.
filetype plugin on
filetype indent off

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcCommands
autocmd!

autocmd BufRead,BufNewFile *.pde  set filetype=cpp
autocmd BufRead,BufNewFile *.ncss set filetype=css

autocmd FileType text       setlocal textwidth=78
autocmd FileType html       setlocal ts=2 sw=2 sts=2
autocmd FileType xhtml      setlocal ts=2 sw=2 sts=2
autocmd FileType css        setlocal ts=2 sw=2 sts=2
autocmd FileType javascript setlocal ts=2 sw=2 sts=2
autocmd FileType cpp        setlocal ts=2 sw=2 sts=2
autocmd FileType ruby       setlocal ts=2 sw=2 sts=2
autocmd FileType eruby      setlocal ts=2 sw=2 sts=2
autocmd FileType cucumber   setlocal ts=2 sw=2 sts=2

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

augroup END

