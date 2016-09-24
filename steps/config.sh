link_config_files agignore gitignore tmate.conf tmux.conf zshrc

# Disable the dashboard.
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Clear out the dock.
defaults write com.apple.dock checked-for-launchpad -boolean YES
defaults write com.apple.dock persistent-apps "()"
defaults write com.apple.dock orientation left
killall Dock

# Set up menu bar extras.
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu"
killall SystemUIServer

# Hide the desktop.
defaults write com.apple.finder CreateDesktop false
killall Finder
