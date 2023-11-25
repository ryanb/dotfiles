# shellcheck shell=bash

# Don't show recents in the dock.
defaults write com.apple.dock show-recents -boolean FALSE
killall Dock

# Don't have the nn key open the emoji picker.
# This doesn't seem to stick until a logout. :(
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# Turn on filevault.
if ! fdesetup status | grep -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
  sudo fdesetup enable -user "$USER" | tee ~/Desktop/"FileVault Recovery Key.txt"
fi

# Turn on the firewall.
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Make key repeats work properly in Warp.
# (Hopeufully Warp will fix this soon.)
defaults write dev.warp.Warp-Stable ApplePressAndHoldEnabled -bool false
