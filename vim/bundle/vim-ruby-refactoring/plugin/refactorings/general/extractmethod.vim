" Synopsis:
"   Extracts the selected scope into a method above the scope of the
"   current method
function! ExtractMethod() range
  try
    let name = common#get_input("Method name: ", "No method name given!")
  catch
    echo v:exception
    return
  endtry
  
  let [block_start, block_end] = common#get_range_for_block('\<def\>','Wb')

  let pre_selection = join( getline(block_start+1,a:firstline-1), "\n" )
  let pre_selection_variables = s:ruby_determine_variables(pre_selection)

  let post_selection = join( getline(a:lastline+1,block_end), "\n" )
  let post_selection_variables = s:ruby_determine_variables(post_selection)

  let selection = common#cut_visual_selection()
  let selection_variables = s:ruby_determine_variables(selection)

  let parameters = []
  let retvals = []

  " determine parameters
  for var in selection_variables[1]
    call insert(parameters,var)
  endfor

  for var in selection_variables[0]
    if index(post_selection_variables[1], var) != -1
      call insert(retvals, var)
    endif
  endfor

  call s:em_insert_new_method(name, selection, parameters, retvals, block_start)
endfunction

function! s:ruby_determine_variables(block) 
  let tokens = s:ruby_tokenize(a:block)
  let statements = s:ruby_identify_tokens(tokens)

  let assigned = []
  let referenced = []

  for statement in statements 
    call s:ruby_identify_methods( statement )
    let results = s:ruby_identify_variables( statement )
    call extend(assigned,results[0])
    call extend(referenced,results[1])
  endfor

  call common#dedupe_list(assigned)
  call common#dedupe_list(referenced)

  return [assigned,referenced]
endfunction

" Synopsis:
" Splits a block of code into individual statements, then splits said
" statements into individual tokens (variables, operators, symbols, etc)
function! s:ruby_tokenize( block )
  let stripped_block = tr( a:block, "\n\r\t", ";  " )
  let tokens = []

  let ofs = 0
  while 1
    let a = matchstr( stripped_block, '\v^(#|;|,|\(|\)|\d+\.\d+|(\:|\@)?\w+|\s+|\''[^\'']*\''|\"[^\"]*\"|\=|\S+)', ofs )
    if a == ""
      break
    endif
    let ofs = ofs + len(a)
    call add(tokens,a)
  endwhile

  return tokens
endfunction

" Synopsis:
" Determines what each of a list of strings is with respect to the ruby
" language.  E.g. keywords, operators, variables, methods
"
" TODO: Improve this with ref to http://www.zenspider.com/Languages/Ruby/QuickRef.html#4 
function! s:ruby_identify_tokens( tokenlist )
  let symbols = []
  let statements = []
  let reserved = [ "alias", "and", "BEGIN", "begin", "break", "case", "class", "def", "defined?", "do", "else", "elsif", "END", "end", "ensure", "false", "for", "if", "in", "module", "next", "nil", "not", "or", "redo", "rescue", "retry", "return", "self", "super", "then", "true", "undef", "unless", "until", "when", "while", "yield" ]

  let ignore_to_eos = 0

  for token in a:tokenlist
    if index(reserved,token) != -1
      let sym = "KEYWORD"
    elseif match(token, '\v^\s+$') != -1
      let sym = "WS"
    elseif match(token, '\v^\:\w+$') != -1
      let sym = "SYMBOL"
    elseif match(token, '\v^\I\i*$') != -1
      let sym = "VAR"
    elseif match(token, '\v^\@\I\i*$') != -1
      let sym = "IVAR"
    elseif match(token, '\v^\d+(\.\d+)?$') != -1
      let sym = "CONST"
    elseif token[0] == "'" || token[0] == '"'
      let sym = "STR"
    elseif token == '#' 
      let ignore_to_eos = 1
    elseif token == '=' 
      let sym = 'ASSIGN'
    elseif token == ',' 
      let sym = 'COMMA'
    elseif token == '"' 
      let sym = 'DQUOTE'
    elseif token == "'" 
      let sym = 'SQUOTE'
    elseif token == '(' 
      let sym = 'LPAREN'
    elseif token == ')' 
      let sym = 'RPAREN'
    elseif token == ';' 
      let sym = "EOS"
      if len(symbols) > 0 
        call add(statements, symbols)
        let symbols = []
        let ignore_to_eos = 0
        continue
      endif
    else
      let sym = "OPER"
    endif

    if ignore_to_eos == 1
      let sym = "COMMENT"
    endif

    if sym != "WS" 
      call add(symbols,[sym,token])
    endif
  endfor

  if len(symbols) > 1
    call add(statements,symbols)
  endif

  return statements
endfunction

" Synopsis:
" Has a stab (badly) at working out if a string is a method or a variable
" TODO: Improve this by searching through the current file for the name
" preceded by 'def'
function! s:ruby_identify_methods( tuples )
  let lasttuple = []
  for tuple in a:tuples 
    let lastsym = get(lasttuple,0,"")
    let sym = tuple[0]
    if ((sym == "LPAREN") && (lastsym == "VAR")) || ((sym == "VAR") && (lastsym == "VAR")) || ((sym == "STR" && lastsym == "VAR"))
      let lasttuple[0] = "METHOD"
    endif
    let lasttuple = tuple
  endfor
endfunction

" Synopsis:
" Takes a list of variables and tries to work out if the variable has been
" assigned to OR used in a comparison.  This determines which variables need
" to be passed into the new method, and which need to be returned.
" TODO: Change the name of this, it's misleading
function! s:ruby_identify_variables( tuples )
  let assigned = []
  let referenced = []

  for tuple in a:tuples
    if tuple[0] == "ASSIGN"
      let assigned = deepcopy(referenced)
      let referenced = []
    elseif tuple[0] == "VAR" 
      call add(referenced,tuple[1])
    endif
  endfor

  return [assigned, referenced]
endfunction

" Synopsis:
" Do the vim bit of creating the new method, and the call to it.
function! s:em_insert_new_method(name, selection, parameters, retvals, block_start)
  " Remove last \n if it exists, as we're adding one on prior to the 'end'
  let has_trailing_newline = strridx(a:selection,"\n") == (strlen(a:selection) - 1) ? 1 : 0

  " Build new method text, split into a list for easy insertion
  let method_params = ""
  if len(a:parameters) > 0 
    let method_params = "(" . join(a:parameters, ",") . ")"
  endif

  let method_retvals = ""
  if len(a:retvals) > 0 
    let method_retvals = join(a:retvals,", ")
  endif

  let method_lines = split("def " . a:name . method_params . "\n" . a:selection . (has_trailing_newline ? "" : "\n") . (len(a:retvals) > 0 ? "return " . method_retvals . "\n" : "") . "end\n", "\n", 1)

  " Start a line above, as we're appending, not inserting
  let start_line_number = a:block_start - 1

  " Sanity check
  if start_line_number < 0 
    let start_line_number = 0
  endif

  " Insert new method
  call append(start_line_number, method_lines) 

  " Insert call to new method, and fix up the source so it makes sense
  if has_trailing_newline
    exec "normal i" . (len(a:retvals) > 0 ? method_retvals . " = " : "") . a:name . method_params . "\n"
    normal k
  else
    exec "normal i" . a:name 
  end

  " Reset cursor position
  let cursor_position = getpos(".")

  " Fix indent on call to method in case we corrupted it
  normal V=
  
  " Indent new codeblock
  exec "normal " . start_line_number . "GV" . len(method_lines) . "j="

  " Jump back again, 
  call setpos(".", cursor_position)

  " Visual mode normally moves the caret, go back
  if has_trailing_newline 
    normal $
  endif
endfunction
