" ==============================================================================
" Configuration

set nocompatible

execute pathogen#infect()

set autoindent
set autoread
set autowriteall
set dir=/tmp
set expandtab
set hidden
set incsearch
set wildmode=list:longest

syntax enable

" Use ITerm for the vim-rspec plugin.
let g:rspec_command = "silent !~/.bin/run_in_iterm 'bundle exec rspec {spec}'"


" ==============================================================================
" Key bindings

let mapleader=","

noremap <Leader>b :LustyBufferExplorer<CR>
noremap <Leader>f :LustyFilesystemExplorer<CR>
noremap <Leader>r :LustyFilesystemExplorerFromHere<CR>
noremap <Leader>t :CtrlP<CR>
noremap <Leader>s :call RunCurrentSpecFile()<CR>

" Use CTRL-direction to navigation windows.
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Reselect the visual area when changing indenting in visual mode.
vnoremap < <gv
vnoremap > >gv


" ==============================================================================
" Filetype settings

filetype plugin on

augroup vimrcCommands
autocmd!

autocmd FileType ruby  setlocal ts=2 sw=2 sts=2
autocmd FileType eruby setlocal ts=2 sw=2 sts=2
autocmd FileType vim   setlocal ts=2 sw=2 sts=2

" Remove whitespace at the end of lines on save.
" See http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e

autocmd BufWritePost .vimrc source $MYVIMRC

augroup END


" ==============================================================================
" GUI settings

if has("gui_macvim")
  set background=dark
  colorscheme grb256
  set gfn=Inconsolata:h14
  set linespace=1

  " Hide the scrollbars.
  set guioptions-=L
  set guioptions-=r
end
