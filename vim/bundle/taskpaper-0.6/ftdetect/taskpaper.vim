" Vim filetype detection file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-02-15
"
augroup taskpaper
     au! BufRead,BufNewFile *.taskpaper   setfiletype taskpaper
     au FileType taskpaper setlocal noexpandtab shiftwidth=4 tabstop=4
augroup END
