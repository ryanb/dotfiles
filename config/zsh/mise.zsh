if [[ -f $HOMEBREW_PREFIX/bin/mise ]] {
  if [[ -o interactive ]] {
    eval "$(mise activate zsh)"
  } else {
    eval "$(mise activate zsh --shims)"
  }
}
