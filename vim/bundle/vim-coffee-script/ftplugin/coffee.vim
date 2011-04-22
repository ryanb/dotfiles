" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=s:###,m:\ ,e:###,:#
setlocal commentstring=#\ %s

" Fold by indentation, but only if enabled.
setlocal foldmethod=indent

if !exists("coffee_folding")
  setlocal nofoldenable
endif

" Compile some CoffeeScript.
command! -range=% CoffeeCompile <line1>,<line2>:w !coffee -scb

" Compile the current file on write.
if exists("coffee_compile_on_save")
  autocmd BufWritePost,FileWritePost *.coffee silent !coffee -c <afile> &
endif
