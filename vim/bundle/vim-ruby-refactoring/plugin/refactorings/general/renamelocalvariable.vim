" Synopsis:
"   Rename the selected local variable 
function! RenameLocalVariable()
  try
    let selection = common#get_visual_selection()

    " If @ at the start of selection, then abort
    if match( selection, "@" ) != -1
      throw "Selection '" . selection . "' is not a local variable"
    endif

    let name = common#get_input("Rename to: ", "No variable name given!" )
  catch
    echo v:exception
    return
  endtry

  " Find the start and end of the current block
  " TODO: tidy up if no matching 'def' found (start would be 0 atm)
  let [block_start, block_end] = common#get_range_for_block('\<def\>','Wb')

  " Rename the variable within the range of the block
  call common#gsub_all_in_range(block_start, block_end, '[^@]\<\zs'.selection.'\>\ze\([^\(]\|$\)', name)
endfunction

