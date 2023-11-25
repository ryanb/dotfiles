if [[ -f $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh ]] {
  source $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh

  if [[ -d ~/.asdf/plugins/java/ ]] {
    source ~/.asdf/plugins/java/set-java-home.zsh
  }
}
