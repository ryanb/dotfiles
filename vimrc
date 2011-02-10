" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load pathogen for managing all those pesky plugins.
" Load this first so ftdetect in bundles works properly.
call pathogen#runtime_append_all_bundles() 

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

syntax on               " enable syntax highlighting
set history=50          " keep 50 lines of command line history
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set hlsearch            " highlight search results
set mouse=a             " enable the mouse
set expandtab           " always use spaces not tabs
set ts=2 sw=2 sts=2     " default to 2 space tabs
set autoindent nosmartindent nocindent  " go for simple autoindenting
set hidden              " unload any buffer that's hidden
set wildmode=list:longest  " list options when completing on the command line

" Set up the status line
set laststatus=2        " Always show it.
set statusline=%([%M%R%H%W]\ \ %)%l/%L\ \ %f%=%{&filetype}\ \ %c

" Put swap files in /tmp, and don't keep backups.
set dir=/tmp
set nobackup

" Set up folding.
set foldenable         " enable code folding
set foldmethod=syntax  " use syntax for folding
set foldlevelstart=99  " open all folds by default
set foldtext=getline(v:foldstart)
set fillchars=fold:\ 

if has("gui_macvim")
  set mousehide                   " Hide the mouse when typing text.
  set guioptions=egm              " Show tabs, hide toolbar and scrollbar.
  set fuoptions=maxvert,maxhorz   " Go to full width and height in full screen mode.

  set gfn=Inconsolata:h15         " Inconsolata 15px for the font
  set linespace=0                 " 0 pixels between lines

  colorscheme railscasts

  " Leave insert mode when vim loses focus. Doesn't work. :(
  autocmd FocusLost * :stopinsert

  " Better colours for folding.
  highlight Folded guifg=#EEEEEE guibg=#333333
endif


" Plugin Configuration
" --------------------

" Stop Lusty Juggler complaining when we use the system vim.
let g:LustyJugglerSuppressRubyWarning = 1

" Show relative paths in bufexplorer.
let g:bufExplorerShowRelativePath=1
" Hide the default help in bufexplorer.
let g:bufExplorerDefaultHelp=0

" Let single clicks open file and directories.
let g:NERDTreeMouseMode=3
" Close NERDTree after opening a file.
let g:NERDTreeQuitOnOpen=1


" Custom Key Mappings
" -------------------

" Disable the F1 key (which normally opens help) coz I hit it accidentally.
noremap <F1> <nop>

" noremap ,a :BufExplorer<CR>
noremap ,a :LustyBufferExplorer<CR>
noremap ,f :LustyFilesystemExplorer<CR>
noremap ,r :LustyFilesystemExplorerFromHere<CR>
noremap ,t :CommandT<CR>

" Use CTRL-J and CTRL-K to skip forward and back through functions.
map <C-K> [m
map <C-J> ]m

" Use CTRL-N and CTRL-P to skip forward and back through the quickfix list.
noremap <C-P> :cp<CR>
noremap <C-N> :cn<CR>

" Use CTRL-A to re-align ruby, SQL, and cucumber in visual mode.
vnoremap <C-A> !align-ruby<CR>

" Reselect the visual area when changing indenting in visual mode.
vnoremap < <gv
vnoremap > >gv

" Don't use Ex mode, use Q for formatting.
noremap Q gq
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>


" Filetype Handling
" -----------------

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
autocmd FileType markdown   setlocal ts=4 sw=4 sts=4

augroup END
