# Don't show recents in the dock.
defaults write com.apple.dock show-recents -boolean FALSE
killall Dock

# Turn on filevault.
if ! fdesetup status | grep -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
  sudo fdesetup enable -user "$USER" | tee ~/Desktop/"FileVault Recovery Key.txt"
fi

# Turn on the firewall.
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
