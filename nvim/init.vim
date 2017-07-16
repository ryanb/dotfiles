" ==============================================================================
" General config

source ~/.config/nvim/vimplug.vim

set termguicolors

set statusline=%f\ %h%m%r%=%l/%L

set tabstop=2 shiftwidth=2 softtabstop=2
filetype indent off
set expandtab
set breakindent

set nofoldenable

set relativenumber
set cursorline

set wildmode=list:longest

set incsearch
set inccommand=split

set showcmd
set belloff=esc

set mouse=a

set hidden

" This is so gf will find files in the Sites app properly.
set path+=ui,.


" ==============================================================================
" Key bindings

let mapleader=","

nnoremap <Leader>s :wa<CR>

" Better split management
nnoremap <Leader>- :sp<CR>
nnoremap <Leader>\ :vs<CR>
nnoremap <Leader>x <C-W>c
nnoremap <Leader>o <C-W>o

" Reselect the visual area when changing indenting in visual mode.
vnoremap < <gv
vnoremap > >gv


" ==============================================================================
" Plugin Config

" ctrlp
let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_cmd = 'CtrlPRoot'
let g:ctrlp_by_filename = 1

nnoremap <silent> <Leader>b :CtrlPBuffer<CR>
nnoremap <silent> <Leader>r :CtrlP<CR>

" vim-tmux-navigator
let g:tmux_navigator_command = $TMUX_COMMAND

if has('nvim')
  nnoremap <silent> <BS> :TmuxNavigateLeft<CR>
endif

" vim-test
let test#strategy = "neoterm"

nnoremap <Leader>t :wa<CR>:TestFile<CR>

" vim-jsx
let g:jsx_ext_required = 0  " Treat .js files as JSX

" ale
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = { 'javascript': ['standard'] }
let g:ale_javascript_standard_use_global = 1
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '?'

" ==============================================================================
" Autocmds

augroup vimrcCommands
autocmd!

" Remove whitespace at the end of lines on save.
" See http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e

autocmd FocusGained * highlight StatusLine guifg=#22aa33
autocmd FocusLost * highlight StatusLine guifg=#555555

autocmd InsertEnter * highlight StatusLine guifg=#2233aa
autocmd InsertLeave * highlight StatusLine guifg=#22aa33

augroup END


" ==============================================================================
" Colors

colorscheme Tomorrow-Night-Bright

" Highlight the active window more brightly:
highlight StatusLine guifg=#2233aa guibg=white
set fillchars+=vert:\  " That space after the \ is significant.
