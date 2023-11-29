# This is based on https://github.com/ohmyzsh/ohmyzsh

## ALIASES

alias be="bundle exec"


## GEM WRAPPER

bundled_commands=(
  cap
  capify
  cucumber
  guard
  hanami
  irb
  jekyll
  pry
  puma
  rackup
  rake
  rspec
  rubocop
  sidekiq
  spring
  thin
  unicorn
  unicorn_rails
)

# Check if in the root or a subdirectory of a bundled project
_within-bundled-project() {
  local check_dir="$PWD"
  while [[ "$check_dir" != "/" ]]; do
    if [[ -f "$check_dir/Gemfile" || -f "$check_dir/gems.rb" ]]; then
      return 0
    fi
    check_dir="${check_dir:h}"
  done
  return 1
}

_run-with-bundler() {
  if (( ! $+commands[bundle] )) || ! _within-bundled-project; then
    "$@"
    return $?
  fi

  if [[ -f "./bin/${1}" ]]; then
    ./bin/${^^@}
  else
    bundle exec "$@"
  fi
}

for cmd in $bundled_commands; do
  # Create wrappers for bundled and unbundled execution
  eval "function unbundled_$cmd () { \"$cmd\" \"\$@\"; }"
  eval "function bundled_$cmd () { _run-with-bundler \"$cmd\" \"\$@\"; }"
  alias "$cmd"="bundled_$cmd"

  # Bind completion function to wrapped gem if available
  if (( $+functions[_$cmd] )); then
    compdef "_$cmd" "bundled_$cmd"="$cmd"
  fi
done
unset cmd bundled_commands
