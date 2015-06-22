" ==============================================================================
" Configuration

source ~/.vundle

set autoindent
set autoread
set autowriteall
set dir=/tmp
set expandtab
set hidden
set incsearch
set laststatus=2
set statusline=%f\ %h%m%r%=%l/%L
set wildmode=list:longest
set mouse=a

syntax enable

let g:turbux_command_prefix = 'bundle exec'


" ==============================================================================
" Key bindings

let mapleader=","

noremap <Leader>b :LustyBufferExplorer<CR>
noremap <Leader>f :LustyFilesystemExplorer<CR>
noremap <Leader>r :LustyFilesystemExplorerFromHere<CR>
noremap <Leader>w :wa<CR>

noremap <Leader>ah :Tab /=><CR>

" Reselect the visual area when changing indenting in visual mode.
vnoremap < <gv
vnoremap > >gv


" ==============================================================================
" Filetype settings

filetype plugin on

augroup vimrcCommands
autocmd!

" Without this, .md files are treated as Modula-2!
autocmd BufRead,BufNewFile *.md  set filetype=markdown

autocmd FileType ruby     setlocal ts=2 sw=2 sts=2
autocmd FileType eruby    setlocal ts=2 sw=2 sts=2
autocmd FileType vim      setlocal ts=2 sw=2 sts=2
autocmd FileType markdown setlocal ts=4 sw=4 sts=4 linebreak
autocmd FileType puppet   setlocal ts=2 sw=2 sts=2
autocmd FileType html     setlocal ts=2 sw=2 sts=2

" Remove whitespace at the end of lines on save.
" See http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e

autocmd BufWritePost .vimrc source $MYVIMRC
autocmd BufWritePost .vundle source $MYVIMRC

augroup END


" ==============================================================================
" GUI settings

if has("gui_macvim")
  set background=dark
  colorscheme grb256
  set gfn=Inconsolata:h14
  set linespace=1

  " Make the statusline readable.
  highlight StatusLineNC guibg=#222222 guifg=#666666

  " Hide the scrollbars.
  set guioptions-=L
  set guioptions-=r
end
