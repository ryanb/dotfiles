c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# autocorrect is more annoying than helpful
unsetopt correct_all

if [[ -n $SSH_CONNECTION ]]; then
  PROMPT='%m:%3~$(git_prompt_info [ ])%# '
else
  PROMPT='%3~$(git_prompt_info [ ])%# '
fi
