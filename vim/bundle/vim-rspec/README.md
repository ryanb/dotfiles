# rspec.vim

This is a lightweight RSpec runner for Vim and MacVim.

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Bundle 'thoughtbot/vim-rspec'
```

If using zsh on OS X it may be necessary to move `/etc/zshenv` to `/etc/zshrc`.

## Configuration

### Key mappings

Add your preferred key mappings to your `.vimrc` file.

```vim
" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
```

### Custom command

Overwrite the `g:rspec_command` variable to execute a custom command.

Example:

```vim
let g:rspec_command = "!rspec --drb {spec}"
```

This `g:rspec_command` variable can be used to support any number of test
runners or pre-loaders. For example, you can use
[Dispatch](https://github.com/tpope/vim-dispatch) and
[Zeus](https://github.com/burke/zeus) together with the following:

```vim
let g:rspec_command = "Dispatch zeus rspec {spec}"
```

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

rspec.vim is maintained by [thoughtbot, inc](http://thoughtbot.com/community)
and [contributors](https://github.com/thoughtbot/vim-rspec/graphs/contributors)
like you. Thank you!

It was strongly influenced by Gary Bernhardt's [Destroy All
Software](https://www.destroyallsoftware.com/screencasts) screencasts.

## License

rspec.vim is copyright © 2013 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
