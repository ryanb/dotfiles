" Synopsis: 
"   converts a post-conditional expression to a conditional expression
"   note: will convert both types of conditional expression
function! ConvertPostConditional()
  " pattern to match
  let conditional_operators = '\<if\|unless\|while\|until\>'
  " save the current line
  let current_line = line('.')
  " go to end of current line
  normal $
  " find the first match for a conditional operator
  let first_match = search(conditional_operators, 'bnW')

  " if the first match isn't on the current line, exit.
  if current_line != first_match
    return
  endif

  " move the cursor to the first found conditional operator
  call search(conditional_operators, 'bW')
  " save original value of buffer a into temp variable
  let original_value = @a
  " delete to the end of the line into buffer a
  normal "ad$
  " insert new line above
  normal O
  " and paste buffer a
  normal "ap
  " indent conditional properly
  normal ==
  " restore original value back to register a
  let @a = original_value
  " move one line down and add 'end'
  exec "normal jo" . "end"
  " move back to the line that you started at
  normal k
  " indent the conditional body
  normal >>
endfunction
