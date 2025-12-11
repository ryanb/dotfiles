c() {
  local code_path="${CODE_PATH:-$HOME/code}"
  local base_path="${code_path%%:*}"
  if [[ -z "$1" ]]; then
    local selected=$(echo "$code_path" | tr ':' '\n' | while read -r dir; do
      for d in "$dir"/*/; do
        [[ -d "$d" ]] && echo "$(stat -f %m "$d") $d"
      done
    done | sort -n | cut -d' ' -f2- | sed "s|$base_path/||;s|/$||" | fzf --tac)
    [[ -n "$selected" ]] && cd "$base_path/$selected"
  else
    cd "$base_path/$1"
  fi
}
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
