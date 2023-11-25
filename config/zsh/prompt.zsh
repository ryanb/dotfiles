NEWLINE=$'\n'

PATH_PROMPT_INFO='%F{blue}%~%f'

autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vsc_info:*' check-for-staged-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats '%F{green}[%b%u%c]%f'
function precmd { vcs_info }

setopt prompt_subst
PROMPT='${NEWLINE}${PATH_PROMPT_INFO} ${vcs_info_msg_0_} %# '
