#!/usr/bin/env bash

wget https://raw.githubusercontent.com/dbldots/dotfiles/master/files/_tmux.conf -O ~/.johannes.tmux.conf
tmux new-session -d -s johannes
tmux send-keys -t johannes 'tmux source-file ~/.johannes.tmux.conf' C-j
tmux attach -t johannes
