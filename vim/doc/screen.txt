*screen.txt*

Author: Eric Van Dewoestine <ervandew@gmail.com>

This plugin is licensed under the terms of the BSD License.  Please see
screen.vim for the license in its entirety.

-----------------------------------------------------------------------------
Screen                                      *screen*

Introduction                         |screen-intro|
Screen Usage                         |screen-usage|
  :ScreenShell                       |screen-shell|
  :ScreenShellAttach                 |screen-shellattach|
  :ScreenSend                        |screen-send|
  :ScreenQuit                        |screen-quit|
Screen Options                       |screen-options|
  Terminal muliplexer                |screen-impl|
  Shell height                       |screen-shellheight|
  Quit on exit                       |screen-quitonexit|
  External shell                     |screen-externalshell|
  Server name                        |screen-servername|
  Terminal                           |screen-terminal|
Custom mappings                      |screen-mappings|
Script integration                   |screen-scriptintegration|
Gotchas                              |screen-gotchas|
Troubleshooting                      |screen-troubleshooting|

-----------------------------------------------------------------------------
Introduction                                *screen-intro*

This plugin aims to simulate an embedded shell in vim by allowing you to
easily convert your current vim session into one running in gnu screen with a
split gnu screen window containing a shell, and to quickly send
statements/code to whatever program is running in that shell (bash, python,
irb, etc.).  Spawning the shell in your favorite terminal emulator is also
supported for gvim users or anyone else that just prefers an external shell.

Currently tested on Linux and Windows (win32 gvim and cygwin vim), but
should also work on any unix based platform where screen is supported (OSX,
BSD, Solaris, etc.).  Note that in my testing of cygwin, invocations of screen
were significantly slower and less fluid than on Linux.  The Windows
experience is better when using gvim to spawn a cygwin shell running screen.

Tmux Users: On non-windows systems, tmux is also supported in place of gnu
screen.  To use tmux simply add the following to your vimrc:
  let g:ScreenImpl = 'Tmux'

  Note: With tmux, :ScreenShellAttach is currently not supported.

Windows Users: Whether you are using gvim or not, you will need cygwin
installed with cygwin's bin directory in your windows PATH.

-----------------------------------------------------------------------------
Screen usage                                *screen-usage*

Here is a sample workflow utilizing screen.vim to execute some python code in
the python interactive interpreter:

  1. Edit a python file
     $ vim something.py

  2. Decide you want to run all or pieces of the code in an interactive python
     shell
     :ScreenShell python

  3. Send code from a vim buffer to the shell
     :ScreenSend

  4. Quit the screen session and return to your original vim session
    :ScreenQuit
      or
    :qa

Below is a comprehensive list of the commands which screen.vim provides:

:ScreenShell [cmd]                  *screen-shell* *:ScreenShell*
  Starts a screen hosted shell performing the following steps depending on
  your environment.

  When running a console vim on a unix based OS (Linux, BSD, OSX):
    1. save a session file from your currently running vim instance
       (current tab only)
    2. start gnu screen with vim running in it
    3. load your saved session file
    4. create a lower gnu screen split window and start a shell, or if
       g:ScreenShellExternal is set, start an external terminal with
       screen running.
    5. if a command was supplied to :ScreenShell, run it in the new
       shell.
       Ex. :ScreenShell ipython

    Note: If you are already in a gnu screen session, then only steps
          4 and 5 above will be run.

  When running gvim:
    1. start an external terminal with screen running.
    2. if a command was supplied to :ScreenShell, run it in the new
       shell.
       Ex. :ScreenShell ipython

:ScreenShellVertical [cmd]     *screen-shell-vertical* *:ScreenShellVertical*
  Just like |:ScreenShell| but when creating the split region for the shell, a
  vertical split is used instead of the default horizontal split.  Supported
  via tmux by default, but gnu screen requires the vertical split patch
  (http://fungi.yuggoth.org/vsp4s/) or the unreleased screen 4.1 code and you
  must explicitly enable support for gnu screen vertical splitting in
  screen.vim by adding the following to your vimrc, indicating whether you are
  using a patched gnu screen or the 4.1 code base:
    let g:ScreenShellGnuScreenVerticalSupport = 'patch'
      or
    let g:ScreenShellGnuScreenVerticalSupport = 'native'


:ScreenShellAttach [session]        *screen-shellattach* *:ScreenShellAttach*
  Sets the necessary internal variables to allow :ScreenSend invocations to
  send to the specified screen session.  If no session is provided, then the
  first session found is used.  If the session is in the "Detached" state,
  then a new terminal is opened with a new screen instance attached to the
  session. Attaching to a detached session is not currently supported on
  windows due to deficiencies in the cygwin version of gnu screen.

  Note: for screen sessions attached to via this mechanism, :ScreenSend
  invocations will send the text to the active screen window instead of
  targeting the 'shell' window when used from :ScreenShell.  However, this
  behavior can be configured via the g:ScreenShellAttachTargetCurrent
  variable, which when non 0, will set the title on the currently focused gnu
  screen window and target it for all send commands.

:ScreenSend
  Send the visual selection or the entire buffer contents to the running gnu
  screen shell window.

:ScreenQuit
  Save all currently modified vim buffers and quit gnu screen, returning you
  to your previous vim instance running outside of gnu screen

  Note: :ScreenQuit is not available if you where already in a gnu
    screen session when you ran :ScreenShell.
  Note: By default, if the gnu screen session was started by
    :ScreenShell, then exiting vim will quit the gnu screen session as
    well (configurable via g:ScreenShellQuitOnVimExit).


-----------------------------------------------------------------------------
Screen Options                              *screen-options*

Screen is configured via several global variables that you can set in your
|vimrc| file according to your needs. Below is a comprehensive list of the
variables available.

Terminal Multiplexer                        *screen-impl*
                                            *g:ScreenImpl*

g:ScreenImpl (default value: 'GnuScreen')

This sets the name of the terminal multiplexer you want to use.  Support
values include 'GnuScreen' or 'Tmux'.


Shell height                                *screen-shellheight*
                                            *g:ScreenShellHeight*

g:ScreenShellHeight (default value: 15)

Sets the height of the gnu screen (or tmux) region used for the shell.  When
the value is less than or equal to 0, then half of vim's reported window
height will be used.


Shell width                                 *screen-shellwidth*
                                            *g:ScreenShellWidth*

g:ScreenShellWidth (default value: -1)

Sets the width of the gnu screen (or tmux) region used for the shell when
splitting the region vertically (vertical split support in gnu screen requires
the vertical split patch).  When the value is less than or equal to 0, then
half of vim's reported window width will be used.


Quit on exit                                *screen-quitonexit*
                                            *g:ScreenShellQuitOnVimExit*

g:ScreenShellQuitOnVimExit (default value: 1)

When non-zero and the gnu screen (or tmux) session was started by this script,
the screen session will be closed when vim exits.


External Shell                              *screen-externalshell*
                                            *g:ScreenShellExternal*

g:ScreenShellExternal (default value: 0)

When non-zero and not already in a screen session, an external shell will be
spawned instead of using a split region for the shell.  Note: when using gvim,
an external shell is always used.


Initial focus                               *screen-focus*
                                            *g:ScreenShellInitialFocus*

g:ScreenShellInitialFocus (default value: 'vim')

When set to 'shell' the newly created shell region will be focused when first
creating the shell region.


Server Name                                 *screen-servername*
                                            *g:ScreenShellServerName*

g:ScreenShellServerName (default value: 'vim')

If the gnu screen session is started by this plugin, then the value of this
setting will be used for the servername arg of the vim instance started in the
new gnu screen session (not applicable for gvim users).  The default is 'vim'
unless you have g:ScreenShellExternal enabled, in which case, if you still
want to restart vim in a screen session with a servername, then simply set
this variable in your vimrc.


Terminal                                    *screen-terminal*
                                            *g:ScreenShellTerminal*

g:ScreenShellTerminal (default value: '')

When g:ScreenShellExternal is enabled or you are running gvim, this value will
be used as the name of the terminal executable to be used.  If this value is
empty, a list of common terminals will be tried until one is found.


Expand Tabs                                 *screen-expandtabs*
                                            *g:ScreenShellExpandTabs*

g:ScreenShellExpandTabs (default value: 0)

When sending text from vim to an external program, that program may interpret
tabs as an attempt to perform completion resulting in the text sent not
performing the function you intended.  As a work around, you can set this
setting to a non 0 value resulting in all tabs being expanded to spaces before
sending the text to screen/tmux.

-----------------------------------------------------------------------------
Custom Mappings                             *screen-mappings*

Defining custom key mappings for for screen.vim can be accomplished like with
any other plugin: >
  nmap <C-c><C-c> :ScreenShell<cr>
>

But you may want to have different mappings depending on the whether you have
an active screen shell open or not. For this case screen.vim provides a couple
autocmd groups which you can use to listen for entering or exiting of a screen
shell session.  Here is an example which sets some global key bindings based
on the screen shell state: >

  function! s:ScreenShellListener()
    if g:ScreenShellActive
      nmap <C-c><C-c> :ScreenSend<cr>
      nmap <C-c><C-x> :ScreenQuit<cr>
    else
      nmap <C-c><C-c> :ScreenShell<cr>
    endif
  endfunction

  nmap <C-c><C-c> :ScreenShell<cr>
  augroup ScreenShellEnter
    autocmd User * call <SID>ScreenShellListener()
  augroup END
  augroup ScreenShellExit
    autocmd User * call <SID>ScreenShellListener()
  augroup END
>

You can also take this a step further and do the same as the above, but do so
on a per filetype basis, where the key binding are buffer local and interact
with the filetype's associated interpreter. Here is an example which can be
put in a python ftplugin: >

  function! s:ScreenShellListener()
    if g:ScreenShellActive
      if g:ScreenShellCmd == 'python'
        nmap <buffer> <C-c><C-c> :ScreenSend<cr>
      else
        nmap <buffer> <C-c><C-c> <Nop>
      endif
    else
      nmap <buffer> <C-c><C-c> :ScreenShell python<cr>
    endif
  endfunction

  call s:ScreenShellListener()
  augroup ScreenShellEnter
    autocmd User *.py call <SID>ScreenShellListener()
  augroup END
  augroup ScreenShellExit
    autocmd User *.py call <SID>ScreenShellListener()
  augroup END
>

Note how the :ScreenShell mapping starts the python interpreter. Before
mapping the :ScreenSend command, the function also checks if the shell was
started with the 'python' command, allowing you to unmap (<Nop> in this case
to counter act any global defined mapping) the send command if some other
shell command is running (irb, lisp interpreter, etc).

-----------------------------------------------------------------------------
Script Integration                          *screen-scriptintegration*

To permit integration with your own, or 3rd party, scripts, a funcref is made
globally available while the screen shell mode is enabled, allowing you to
send your own strings to the attached shell.

Here are some examples of using this funcref to send some commands to bash: >
  :call ScreenShellSend("echo foo\necho bar")
  :call ScreenShellSend('echo -e "foo\nbar"')
  :call ScreenShellSend("echo -e \"foo\\nbar\"")
>

Sending a list of strings is also supported: >
  :call ScreenShellSend(["echo foo", "echo bar"])
>

You can test that the funcref exists using: >
   exists('ScreenShellSend')
>

In addition to sending text to the screen shell, another funcref is available
allowing you to focus the shell region in screen.  Note: focusing an external
screen shell is not supported.

To focus the shell region from vim you can invoke the funcref like so: >
  :call ScreenShellFocus()
>

This will focus the bottom most region which is expected to be the one running
your shell or other program.


-----------------------------------------------------------------------------
Gotchas                                     *screen-gotchas*

While running vim in gnu screen, if you detach the session instead of
quitting, then when returning to the non-screen vim, vim will complain about
swap files already existing.  So try to avoid detaching.

Not all vim plugins support saving state to or loading from vim session files,
so when running :ScreenShell some buffers may not load correctly if they are
backed by such a plugin.


-----------------------------------------------------------------------------
Troubleshooting                             *screen-troubleshooting*

Below are a list of possible issues you may encounter and some info on
resolving those issues.

- When already in a screen session, running :ScreenShell results in a nested
  screen session instead of using the existing one.
                                            *screen-bootstrap*

  When running :ScreenShell from a console version of vim, screen.vim examines
  the $TERM environment variable which it expects to start with 'screen'
  ('screen', 'screen-256color', etc.) if you are in an existing screen/tmux
  session.  Should the TERM value not start with 'screen', then screen.vim
  assumes that a screen session must be started for you.

  The cause of TERM not containing a 'screen' values is usually the result of
  having a non-screen term value in your ~/.screenrc or the term value you are
  using doesn't have a corresponding terminfo file resulting in $TERM being
  set to some other value. Take a look at the |screen-256color| docs below for
  more information.

- 256 color support                         *screen-256color*

  To enable 256 color support in screen you'll need to add the following to
  your ~/.screenrc:

    term screen-256color

  Please note that this will set your $TERM to 'screen-256color' which will
  require that your system has a corresponding terminfo file.  Not all systems
  have this installed by default so you may need to install an additional
  package:

    ubuntu - $ apt-get install ncurses-term


vim:tw=78:ts=8:ft=help:norl:
