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


" ==============================================================================
" Key bindings

let mapleader=","

noremap <Leader>b :LustyBufferExplorer<CR>
noremap <Leader>f :LustyFilesystemExplorer<CR>
noremap <Leader>r :LustyFilesystemExplorerFromHere<CR>
noremap <Leader>t :CtrlP<CR>

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
