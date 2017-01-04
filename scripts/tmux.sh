#!/usr/bin/env bash

wget https://raw.githubusercontent.com/dbldots/dotfiles/master/files/_tmux.conf -O ~/.johannes.tmux.conf
tmux
tmux source-file ~/.johannes.tmux.conf
