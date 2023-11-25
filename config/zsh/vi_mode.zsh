bindkey -v
KEYTIMEOUT=1

bar_cursor() { echo -ne "\e[6 q" }
block_cursor() { echo -ne "\e[2 q" }

zle -N zle-line-init bar_cursor

zle-keymap-select() {
  if [[ $KEYMAP = vicmd ]] {
    block_cursor
  } else {
    bar_cursor
  }
}
zle -N zle-keymap-select
