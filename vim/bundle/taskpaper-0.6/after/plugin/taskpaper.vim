" Vim after file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	Morgan Sutherland <m@msutherl.net>
" URL:		https://github.com/msutherl/taskpaper.vim
" Last Change:  2011-01-02
"

" map carriage return to create new todo entry
autocmd filetype taskpaper :nnoremap <buffer> <C-m> o<tab>- 
autocmd filetype taskpaper :inoremap <buffer> <C-m> <ESC>o<tab>- 
