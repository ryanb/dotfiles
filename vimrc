" ==============================================================================
" Configuration

source ~/.vundle

set autoindent
set nosmartindent
set nocindent
set backspace=indent,eol,start
set autoread
set autowriteall
set dir=/tmp
set expandtab
set hidden
set incsearch
set laststatus=2
set statusline=%f\ %h%m%r%=%#warningmsg#%{SyntasticStatuslineFlag()}%*\ %l/%L
set wildmode=list:longest
set mouse=a
set ttimeoutlen=0 " Don't hang around after hitting escape in command mode.
set ts=2 sw=2 sts=2 " Default to 2 space tabs
set foldlevelstart=20
set number
set relativenumber
set cursorline

syntax enable

let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'

let g:tmux_navigator_command = $TMUX_COMMAND

let g:VimuxTmuxCommand = $TMUX_COMMAND

let g:turbux_command_rspec = 'bundle exec rspec'
let g:turbux_command_teaspoon = './node_modules/.bin/jasmine'

let g:jsx_ext_required = 0

let g:syntastic_javascript_checkers = ['standard']


" ==============================================================================
" Key bindings

let mapleader=","

noremap <Leader>b :LustyBufferExplorer<CR>
noremap <Leader>f :LustyFilesystemExplorer<CR>
noremap <Leader>r :LustyFilesystemExplorerFromHere<CR>

" Better split management
noremap <Leader>- :sp<CR>
noremap <Leader>\ :vs<CR>
noremap <Leader>x <C-W>c
noremap <Leader>o <C-W>o

" Handy binding to go with <Leader>t from turbux
noremap <Leader>v :VimuxCloseRunner<CR>

" Shortcut for saving
noremap <Leader>s :wa<CR>

" Reselect the visual area when changing indenting in visual mode.
vnoremap < <gv
vnoremap > >gv


" ==============================================================================
" Filetype settings

filetype plugin on
filetype indent off

augroup vimrcCommands
autocmd!

" Without this, .md files are treated as Modula-2!
autocmd BufRead,BufNewFile *.md  set filetype=markdown

autocmd FileType markdown setlocal linebreak

" Remove whitespace at the end of lines on save.
" See http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e

autocmd BufWritePost .vimrc source $MYVIMRC
autocmd BufWritePost .vundle source $MYVIMRC

autocmd FocusGained * highlight StatusLine ctermfg=35
autocmd FocusLost * highlight StatusLine ctermfg=59

augroup END


" ==============================================================================
" Colors and stuff

colorscheme Tomorrow-Night-Bright

" Highlight the active window more brightly:
highlight StatusLine ctermfg=35

