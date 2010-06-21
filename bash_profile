# Use Ubuntu's nicely coloured prompt, with some git magic.
function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

black_background="\[\033[40m\]"
white="\[\033[1;37m\]"
blue="\[\033[0;34m\]"
yellow="\[\033[1;33m\]"
default_colour="\[\033[0m\]"

# PS1="${black_background}${white}\w${yellow}$(parse_git_branch)${default_colour} "
PS1="${blue}\w${yellow}\$(parse_git_branch)${default_colour} "

# Use vi editing mode.
set -o vi

export CLICOLOR=1                                         # Make ls colour its output.
export LESS=-R                                            # Make less support ANSI colour sequences.
export RUBYOPT=rubygems                                   # Make Ruby load rubygems without a require.
export ACK_OPTIONS="--nosql --type-set cucumber=.feature" # Make ack ignore sql dumps, and search cucumber features.

# We use the full path here to work around this nasty bug: http://www.tpope.net/node/108
# In particular, calling "filetype indent off" in my vimrc was causing vim to
# always exit with a non-zero status. Very annoying for git commit.
export EDITOR=/usr/bin/vim

# Open mvim files in the existing window.
alias mvim='mvim --remote-silent'

# Use fancy bash completion.
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Add developer tools to path
export PATH=$PATH:/Developer/usr/bin
export MANPATH=$MANPATH:/Developer/share/man

# RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add home directory to path.
export PATH=$PATH:~/.bin

