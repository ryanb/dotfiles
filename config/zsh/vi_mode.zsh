bindkey -v
KEYTIMEOUT=1

function bar_cursor { echo -ne "\e[6 q" }
function block_cursor { echo -ne "\e[2 q" }

# Start a new command line with the bar cursor.
zle -N zle-line-init bar_cursor

# Swich between the bar and block cursors depending on the vi mode.
function zle-keymap-select {
  if [[ $KEYMAP = vicmd ]] {
    block_cursor
  } else {
    bar_cursor
  }
}
zle -N zle-keymap-select
