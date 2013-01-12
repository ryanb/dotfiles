" Defines helpers to run shell commands in the current iTerm terminal.

function! s:ITerm(command)
  let l:osascript = "!osascript ~/.bin/iterm.applescript"
  silent execute l:osascript . " " . shellescape(a:command)
endfunction

command! -nargs=1 ITerm call s:ITerm(<f-args>)

