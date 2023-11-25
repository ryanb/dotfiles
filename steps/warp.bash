# shellcheck shell=bash

defaults write dev.warp.Warp-Stable FontName -string '"BerkeleyMono Nerd Font"'
defaults write dev.warp.Warp-Stable FontSize -string "14.0"
defaults write dev.warp.Warp-Stable LineHeightRatio -string "1.4"
defaults write dev.warp.Warp-Stable NewWindowsNumColumns -int 160
defaults write dev.warp.Warp-Stable Autosuggestions -string "false"

# Make key repeats work properly. (Hopeufully Warp will fix this soon.)
defaults write dev.warp.Warp-Stable ApplePressAndHoldEnabled -bool false

echo Installed.
