#!/usr/bin/env bash

wget https://raw.githubusercontent.com/dbldots/dotfiles/master/files/_tmux.conf -O ~/.johannes.tmux.conf
tmux -L johannes new-session -d
tmux -L johannes send-keys 'tmux source-file ~/.johannes.tmux.conf' C-j
tmux -L johannes attach
