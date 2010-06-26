" Vim plugin to change the working directory to the project root
" (identified by the presence of a .git directory).
"
" Copyright 2010 Andrew Stewart, <boss@airbladesoftware.com>
" Released under the MIT licence.
"
" This will happen automatically for typical Ruby webapp files.
"
" You can invoke it manually with <Leader>cd (usually \cd).
" To change the mapping, put this in your .vimrc:
"
"     map <silent> <unique> <Leader>foo <Plug>RooterChangeToRootDirectory
"
" ... where <Leader>foo is your preferred mapping.


"
" Boilerplate
"

if exists("loaded_rooter")
  finish
endif
let loaded_rooter = 1

let s:save_cpo = &cpo
set cpo&vim

"
" Functions
"

" Returns the root directory for the current file, i.e the
" closest parent directory containing a .git directory, or
" an empty string if no such directory is found.
function! s:FindRootDirectory()
  let dir_current_file = expand("%:p:h")
  let git_dir = finddir(".git", dir_current_file . ";")
  " If we're at the project root or we can't find one above us
  if git_dir == ".git" || git_dir == ""
    return ""
  else
    return substitute(git_dir, "/.git$", "", "")
  endif
endfunction

" Changes the current working directory to the current file's
" root directory.
function! s:ChangeToRootDirectory()
  let root_dir = s:FindRootDirectory()
  if root_dir != ""
    exe ":cd " . root_dir
  endif
endfunction

"
" Mappings
"

if !hasmapto("<Plug>RooterChangeToRootDirectory")
  map <silent> <unique> <Leader>cd <Plug>RooterChangeToRootDirectory
endif
noremap <unique> <script> <Plug>RooterChangeToRootDirectory <SID>ChangeToRootDirectory
noremap <SID>ChangeToRootDirectory :call <SID>ChangeToRootDirectory()<CR>

"
" Commands
"

command! Rooter :call <SID>ChangeToRootDirectory()
autocmd BufEnter *.rb,*.html,*.haml,*.erb,*.rjs,*.css,*.js :Rooter

"
" Boilerplate
"

let &cpo = s:save_cpo

" vim:set ft=vim sw=2 sts=2 et:
