" Support functions

" Synopsis:
"   Returns the input given by the user
function! common#get_input(message, error_message)
  let name = input(a:message)
  if name == ''
    throw a:error_message
  endif
  return name
endfunction

" Synopsis:
"   Param: Optional parameter of '1' dictates cut, rather than copy
"   Returns the text that was selected when the function was invoked
"   without clobbering any registers
function! common#get_visual_selection(...) 
  try
    let a_save = @a
    if a:0 >= 1 && a:1 == 1
      normal! gv"ad
    else
      normal! gv"ay
    endif
    return @a
  finally
    let @a = a_save
  endtry
endfunction

" Synopsis:
"   Find pattern to matching end, flags as per :h search()
function! common#get_range_for_block(pattern_start, flags)
  " matchit.vim required 
  if !exists("g:loaded_matchit") 
    throw("matchit.vim (http://www.vim.org/scripts/script.php?script_id=39) required")
  endif

  let cursor_position = getpos(".")

  let block_start = search(a:pattern_start, a:flags)
  normal %
  let block_end = line(".")

  " Restore the cursor
  call setpos(".",cursor_position) 

  return [block_start, block_end]
endfunction

" Synopsis:
"   Loop over the line range given, global replace pattern with replace
function! common#gsub_all_in_range(start_line, end_line, pattern, replace)
  let lnum = a:start_line
  while lnum <= a:end_line
    let oldline = getline(lnum)
    let newline = substitute(oldline,a:pattern,a:replace,'g')
    call setline(lnum, newline)
    let lnum = lnum + 1
  endwhile
endfunction!

" Synopsis:
"   Removed duplicates from a target list
function! common#dedupe_list(target)
  call filter(a:target, 'count(a:target,v:val) > 1 ? 0 : 1') 
endfunction

" Synopsis:
"   Copies, removes, then returns the text that was selected when
"   the function was invoked without clobbering any registers
function! common#cut_visual_selection() 
  return common#get_visual_selection(1)
endfunction
