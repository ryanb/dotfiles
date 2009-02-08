. ~/.zsh/aliases

# changing directory to code project
function c { cd ~/code/$1; }

# alternative to "rails" command to use templates
function railsapp {
  template=$1
  appname=$2
  shift 2
  rails $appname -m http://github.com/ryanb/rails-templates/raw/master/$template.rb $@
}

# misc
alias reload='. ~/.bash_profile'
