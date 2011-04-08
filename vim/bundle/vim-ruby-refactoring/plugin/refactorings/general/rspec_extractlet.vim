" Synopsis:
"   Extracts into an Rspec let declaration
"   Special thanks to ReinH (#vim room at irc.freenode.net)
function! ExtractIntoRspecLet()
  normal! "bdd
  
  exec "?^\\<describe\\|context\\>"
  normal! $p
  exec 's/\v([a-z_][a-zA-Z0-9_]*) \= (.+)/let(:\1) { \2 }'
  normal V=

endfunction
