
" Synopsis:
"   Rename the selected instance variable
function! RenameInstanceVariable()
  try
    let selection = common#get_visual_selection()

    " If no @ at the start of selection, then abort
    if match( selection, "^@" ) == -1
      let left_of_selection = getline(".")[col(".")-2]
      if left_of_selection == "@"
        let selection = "@".selection
      else
        throw "Selection '" . selection . "' is not an instance variable"
      end
    endif

    let name = common#get_input("Rename to: @", "No variable name given!" )
  catch
    echo v:exception
    return
  endtry

  " Assume no prefix given
  let name_no_prefix = name

  " Add leading @ if none provided
  if( match( name, "^@" ) == -1 )
    let name = "@" . name
  else
    " Remove the @ from the no_prefix version
    let name_no_prefix = matchstr(name,'^@\zs.*')
  endif

  " Find the start and end of the current block
  " TODO: tidy up if no matching 'def' found (start would be 0 atm)
  let [block_start, block_end] = common#get_range_for_block('\<class\>','Wb')

  " Rename the variable within the range of the block
  call common#gsub_all_in_range(block_start, block_end, selection.'\>\ze\([^\(]\|$\)', name)

  " copy with no prefix for the attr_* match
  let selection_no_prefix = matchstr( selection, '^@\zs.*' )

  " Rename attr_* symbols
  call common#gsub_all_in_range(block_start, block_end, '^\s*attr_\(reader\|writer\|accessor\).*\:\zs'.selection_no_prefix, name_no_prefix)
endfunction
