on run argv
  tell application "iTerm"
    set myCommand to item 1 of argv
    try
      set mySession to the current session of the current terminal
    on error
      set myTerminal to (make new terminal)
      tell myTerminal
        launch session "Default"
        set mySession to the current session
      end tell
    end try
    tell mySession to write text myCommand
  end tell
end run

