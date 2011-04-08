" Synopsis:
"   Extracts the selected scope into a constant at the top of the current
"   module or class
function! ExtractConstant()
  try
    let name = toupper(common#get_input("Constant name: ", "No constant name given!"))
  catch
    echo v:exception
    return
  endtry

  " Save the scope to register a and then reselect the scope in visual mode
  normal! gv
  " Replace selected text with the constant's name
  exec "normal c" . name
  " Find the enclosing class or module
  exec "?^\\<class\\|module\\>"
  " Define the constant inside the class or module
  exec "normal! o" . name . " = " 
  normal! $p
endfunction
