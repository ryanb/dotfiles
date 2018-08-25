call plug#begin('~/.config/nvim/plugged')

" File Navigation
Plug 'vim-scripts/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Tmux and iTerm integration
Plug 'sjl/vitality.vim'                    " Make Focus(Lost|Gained) work in iTerm & have a bar cursor
" Plug 'tmux-plugins/vim-tmux-focus-events'  " Make Focus(Lost|Gained) work in tmux
Plug 'christoomey/vim-tmux-navigator'      " Navigate between vim and tmux windows

" Testing
" Plug 'kassio/neoterm'
" Plug 'janko-m/vim-test'

" Fancier text object handling
Plug 'tpope/vim-repeat'         " Makes . repeat lots of plugin commands
Plug 'tpope/vim-surround'       " Change surrounding characters
Plug 'vim-scripts/matchit.zip'  " Extend % to work with HTML tags
Plug 'wellle/targets.vim'       " Add a bunch of useful text objects

" General editing
Plug 'vim-scripts/tComment'
Plug 'notahat/vim-redub'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Syntax checking
Plug 'w0rp/ale'

" Languages
Plug 'vim-scripts/textobj-user' | Plug 'vim-scripts/textobj-rubyblock'
Plug 'vim-scripts/rails.vim'
Plug 'pangloss/vim-javascript'
Plug 'moll/vim-node'                     " Make gf work on require statements
" Plug 'elixir-lang/vim-elixir'
Plug 'plasticboy/vim-markdown'
" Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'hashivim/vim-terraform'
" Plug 'fatih/vim-go'
Plug 'fgsch/vim-varnish'
Plug 'leafgarland/typescript-vim'

" Color schemes
Plug 'chriskempson/vim-tomorrow-theme'

call plug#end()
