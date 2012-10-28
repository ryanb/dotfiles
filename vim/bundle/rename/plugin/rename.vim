" Vim plugin to rename the current file.
" Author: Pete Yandell <pete@notahat.com>

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_rename") || &cp
  finish
endif
let g:loaded_rename = 1


command! -nargs=1 -complete=file Rename call s:rename_current_buffer(<f-args>)

function! s:rename_current_buffer(new_name)
  " Make sure errors halt execution.
  try
    let existing_name = bufname("%")

    " Change the name of the current buffer.
    execute "keepalt file " . fnameescape(a:new_name)
    write

    " Delete the old file.
    call delete(l:existing_name)
  endtry
endfunction


let &cpo = s:save_cpo
