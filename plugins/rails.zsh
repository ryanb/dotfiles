# This is based on https://github.com/ohmyzsh/ohmyzsh

# ALIASES

alias rc='rails console'
alias rdb='rails dbconsole'
alias rdm='rails db:migrate'
alias rdmd='rails db:migrate:down'
alias rdmu='rails db:migrate:up'
alias rdr='rails db:rollback'
alias rgen='rails generate'
alias rgm='rails generate migration'


# RAILS COMMAND WRAPPER

function _rails_command () {
  if [ -e "bin/rails" ]; then
    bin/rails $@
  else
    command rails $@
  fi
}

alias rails='_rails_command'
# compdef _rails_command=rails
