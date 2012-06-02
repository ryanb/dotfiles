c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c
