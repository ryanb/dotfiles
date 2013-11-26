* 2013-05-03 - Removed explicit support for Dispatch because it introduces  a
  load order dependency. Set `g:rspec_command` in your .vimrc if you want to
  use Dispatch or any other test runner.
* 2013-04-11 - `RunCurrentSpecFile` and `RunNearestSpec` will fall back to
  `RunLastSpec` if not in spec file.
