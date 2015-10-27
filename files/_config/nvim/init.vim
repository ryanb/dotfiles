set nocompatible
filetype off
" set rtp+=~/.config/vim/
set rtp+=~/.config/nvim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.config/nvim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'gmarik/vundle'
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'
NeoBundle 'Lokaltog/vim-easymotion'
"NeoBundle 'garbas/vim-snipmate'
"NeoBundle 'honza/vim-snippets'
NeoBundle 'ervandew/supertab'
NeoBundle 'kien/ctrlp.vim'
"NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-surround'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-haml'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-easytags'
NeoBundle 'rgarver/Kwbd.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'thinca/vim-fontzoom'
NeoBundle 'vim-scripts/vcscommand.vim'
NeoBundle 'jeffkreeftmeijer/vim-numbertoggle'
NeoBundle 'terryma/vim-smooth-scroll'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'dbakker/vim-projectroot'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'numkil/ag.nvim'

" Themes
NeoBundle 'altercation/vim-colors-solarized'

call neobundle#end()

filetype plugin indent on
syntax on

NeoBundleCheck

set hlsearch " Highlight searches
set incsearch " Do incremental searching
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
set showcmd
"set cmdheight=5
"set scrolloff=10
set wildignore+=*.png,*.jpg,*.gif,*.ai,*.jpeg,*.psd,*.swp,*.jar,*.zip,*.gem,.DS_Store,log/**,tmp/**,coverage/**,rdoc/**,output_*,*.xpi,doc/**
set wildignore+=downloads,tmp,log,download,tags
set wildmode=longest,list:longest
set completeopt=menu,preview

set nobackup       " no backup files
set nowritebackup  " only in case you don't want a backup file while editing
set noswapfile     " no swap files
set background=dark
set number
set ignorecase
set smartcase

" to allow changed buffers to be in the background
set hidden

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set nocompatible
set nowrap

" folding
augroup vimrc
  " fold by default by indendation, but allow manual folding as well
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END
"set foldmethod=indent
"set foldmethod=syntax
set nofoldenable
set foldlevel=1

colorscheme solarized

" set leader key
let mapleader=" "

" toggle line numbers absolute/relative
let g:NumberToggleTrigger="<leader>tl"

" syntastic config
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" ctrlp config
let g:ctrlp_switch_buffer=0
let g:ctrlp_open_multi='vr'
let g:ctrlp_max_height=15
let g:ctrlp_match_window_bottom=0
let g:fuf_modesDisable = [ 'mrufile', 'mrucmd', 'file', 'coveragefile', 'dir' ]

" use ag or git for ctrlP
let g:ctrlp_use_caching = 0
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif

" fancy symbols
let g:Powerline_symbols = 'fancy'

if executable('ctags')
  let g:tagbar_type_coffee = {
    \ 'ctagsbin' : 'coffeetags',
    \ 'ctagsargs' : '',
    \ 'kinds' : [
      \ 'f:functions',
      \ 'o:object',
    \ ],
    \ 'sro' : ".",
    \ 'kind2scope' : {
      \ 'f' : 'object',
      \ 'o' : 'object',
    \ }
  \ }
endif

set mouse+=a
if &term =~ '^screen'
  " tmux knows the extended mouse mode
  set ttymouse=xterm2
endif

" jk triggers ESC in insert mode
inoremap jk <ESC>
" open buffers
map <C-d> :FufBuffer<CR>
" ctrl p for last used files
map <C-s> :CtrlPMRUFiles<CR>
" ctrl + h/l in insert mode
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" instead of CTRL-D and CTRL-U
"noremap <C-j> <C-d>
"noremap <C-k> <C-u>
noremap <silent> <C-k> :call smooth_scroll#up(&scroll, 0, 3)<CR>
noremap <silent> <C-j> :call smooth_scroll#down(&scroll, 0, 3)<CR>

" ag.nvim
map <C-f> :Ag ""<Left>

" to cd to project root
nnoremap <leader>cd :ProjectRootCD<cr>


" open tagbar
map <leader>tb :TagbarToggle<CR>
" toggle line wrapping
map <leader>tw :set wrap!<cr>
" split window
nnoremap <leader>w <C-w>v<C-w>l
" exit with ESC from terminal mode
tnoremap <Esc> <C-\><C-n>
" next quickfix
noremap <leader>n :cn<CR>zv
" remove unwanted whitespaces in empty lines
map <leader>cef :execute "%s/\\s\\+$//e"<CR>
" close buffer
map <leader>x :Kwbd<CR>
" close buffer and window
map <leader>xx :bd<CR>
" close all open buffers
map <leader>X :bufdo Kwbd<CR>
" VCSCommand related
let VCSCommandMapPrefix = "<leader>v"
map <leader>va :VCSAnnotate<CR>
map <leader>vl :VCSLog<CR>
map <leader>vj :call RepoLog()<CR>
map <leader>vd :call RepoDiff()<CR>
map <leader>vv :call RepoShow()<CR>
" toggle highlight search
nnoremap <silent><expr> <Leader>hs (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" toggle paste mode
map <leader>tp :set paste!<CR>

" to cycle through buffers and tabs
"nmap <silent> ,. :bnext<CR>
"nmap <silent> ,m :bprev<CR>
"nmap <silent> ;' :tabnext<CR>
"nmap <silent> ;l :tabprev<CR>
"

" open netrw
map <silent> <C-n> :e.<CR>

"map <silent> <C-n> :Lexplore<CR>
" netrw config
" Hit enter in the file browser to open the selected
" file in previous buffer
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 20
" hide files/directories starting with a dot
let g:netrw_list_hide= '^\.'
" hide help header
"let g:netrw_banner=0

" Default to tree mode
"let g:netrw_liststyle=3

" Change directory to the current buffer when opening files.
set autochdir

function AgRoot()
  :ProjectRootCD
  :Grepper! -tool ag -open -switch
endfunction

function FindRev()
  " TODO try to fix this
  " execute "normal! ^/\\v([a-z0-9]+)((\\d)([a-z])[a-z0-9]+)\<CR>"
  return expand("<cword>")
endfunction

function RepoLog()
  let revision = FindRev()
  execute "VCSLog -r " . revision
endfunction

function RepoDiff()
  let revision = FindRev()
  execute "normal! ^/\\v([a-z0-9]+)((\\d)([a-z])[a-z0-9]+)\<CR>"
  " hash~1 is the git parent revision of hash
  execute "VCSDiff " . expand("<cword>") . "~1 " . expand("<cword>")
endfunction

function RepoShow()
  let revision = FindRev()
  execute "rightbelow new"
  execute "set buftype=nofile"
  execute "set bufhidden=hide"
  execute "setlocal noswapfile"
  " read 'git show #rev'
  execute "r !git show " . revision
  " jump to first line again..
  execute "1"
endfunction
