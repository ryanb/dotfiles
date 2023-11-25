if [[ -f /opt/homebrew/bin/brew ]] {
  eval "$(/opt/homebrew/bin/brew shellenv)"

  FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH

  export HOMEBREW_NO_ENV_HINTS=true
  export EDITOR=$HOMEBREW_PREFIX/bin/nvim
}
