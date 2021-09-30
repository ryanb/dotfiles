link_config_files finicky.js gitignore tool-versions zshrc

# Clear out the dock.
# defaults write com.apple.dock persistent-apps "()"
defaults write com.apple.dock show-recents -boolean FALSE
killall Dock
