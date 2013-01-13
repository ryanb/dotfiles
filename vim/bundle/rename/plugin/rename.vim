" Vim plugin to rename the current file.
" Author: Pete Yandell <pete@notahat.com>

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_rename") || &cp
  finish
endif
let g:loaded_rename = 1

command! -nargs=1 -complete=file RenameBuffer call s:rename_buffer(<f-args>)
command! -nargs=* -complete=file RenameFile call s:rename_file(<f-args>)

function! s:rename_buffer(new_name)
  " Make sure errors halt execution.
  try
    let existing_name = bufname("%")

    " Change the name of the current buffer.
    execute "silent keepalt file " . fnameescape(a:new_name)
    write

    " Delete the old file.
    call delete(l:existing_name)
  endtry
endfunction

" A smart file rename that that handles renaming any open buffers associated
" with the file.
function! s:rename_file(old_name, new_name)
  let l:buffer_number = bufnr(fnamemodify(a:old_name, ":p"))
  if l:buffer_number == -1
    " The buffer isn't open, so just move the file
    call rename(fnamemodify(a:old_name, ":p"), fnamemodify(a:new_name, ":p"))
  else
    " Switch to the file's buffer, rename it, then switch back.
    let l:old_buffer_number = bufnr("%")
    exec "silent keepalt buffer " . l:buffer_number
    call s:rename_buffer(a:new_name)
    exec "silent keepalt buffer " . l:old_buffer_number
  endif
endfunction

let &cpo = s:save_cpo

