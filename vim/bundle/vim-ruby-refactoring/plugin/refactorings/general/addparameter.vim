
" Synopsis:
"   Adds a parameter (or many separated with commas) to a method
function! AddParameter()
  try
    let name = common#get_input("Parameter name: ", "No parameter name given!")
  catch
    echo v:exception
    return
  endtry

  " Save current position
  let cursor_position = getpos(".")

  " Move backwards to the method definiton if you are not already on the
  " correct line
  if empty(matchstr(getline("."), '\<def\>'))
    exec "?\\<def\\>"
  endif

  let closing_bracket_index = stridx(getline("."), ")")

  if closing_bracket_index == -1
    execute "normal A(" . name . ")\<Esc>"
  else
    exec ':.s/)/, ' . name . ')/'
  endif

  " Restore caret position
  call setpos(".", cursor_position)
endfunction

