export PATH=/usr/bin:/bin:/usr/sbin:/sbin

export CLICOLOR=1  # Make ls colour its output.
export LESS=-R     # Make less support ANSI colour sequences.

if [[ $(hostname -s) == Knuth ]] {
  export DOTFILES_ENV=home
} else {
  export DOTFILES_ENV=work
}
