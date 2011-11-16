A custom text object for selecting ruby blocks.

<a href="http://flattr.com/thing/107222/vim-textobj-rubyblock-A-custom-text-object-for-selecting-ruby-blocks" target="_blank">
<img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a>

Depends on Kana's [textobj-user plugin][u]. Test suite requires [vspec][] (also by Kana).

Also requires that the matchit.vim plugin is enabled. Ensure that the following line is included somewhere in your vimrc file:

    runtime macros/matchit.vim

It is also essential that you enable filetype plugins, and disable Vi compatible mode. Placing these lines in your vimrc file will do this:

    set nocompatible
    if has("autocmd")
      filetype indent plugin on
    endif

Usage
=====

When textobj-rubyblock is installed you will gain two new text objects, which
are triggered by `ar` and `ir` respectively. These follow Vim convention, so
that `ar` selects _all_ of a ruby block, and `ir` selects the _inner_ portion
of a rubyblock.

In ruby, a block is always closed with the `end` keyword. Ruby blocks may be
opened using one of several keywords, including `module`, `class`, `def` `if`
and `do`. This example demonstrates a few of these:

    module Foo
      class Bar
        def Baz
          [1,2,3].each do |i|
            i + 1
          end
        end
      end
    end

Suppose your cursor was positioned on the word `def`. Typing `var` would
enable visual mode selecting _all_ of the method definition. Your selection
would comprise the following lines:

    def Baz
      [1,2,3].each do |i|
        i + 1
      end
    end

Whereas if you typed `vir`, you would select everything _inside_ of the method
definition, which looks like this:

    [1,2,3].each do |i|
      i + 1
    end

Note that the `ar` and `ir` text objects always enable _visual line_ mode,
even if you were in visual character or block mode before you triggered the
rubyblock text object.

Note too that the `ar` and `ir` text objects always position your cursor on
the `end` keyword. If you want to move to the top of the selection, you can do
so with the `o` key.

Limitations
-----------

Some text objects in Vim respond to a count. For example, the `a{` text object
will select _all_ of the current `{}` delimited block, but if you prefix it
with the number 2 (e.g. `v2i{`) then it will select all of the block that
contains the current block. The rubyblock text object does not respond in this
way if you prefix a count. This is due to a limitation in the [textobj-user
plugin][u].

However, you can achieve a similar effect by repeating the rubyblock
text-object manually. So if you press `var` to select the current ruby block,
you can expand your selection outwards by repeating `ar`, or contract your
selection inwards by repeating `ir`.

Development
===========

Specs are currently broken. :-/

Running the specs
-----------------

To run the specs, you call vspec as follows:

    vspec {input-script} [{non-standard-runtimepath} ...]

In this case, the non-standard runtimepath must include the vspec plugin, the textobj-user plugin (which is a dependency for this plugin) and this plugin.

Assuming you use [pathogen][] to manage your plugins, then the plugins required to run the test suite will be found in the following locations:

    ~/dotfiles
              /vim
                  /bundle
                         /textobj-user
                         /textobj-rubyblock
                         /vspec

So to run the `basic.input` tests, you would run:

    cd ~/dotfiles/vim/bundle/textobj-rubyblock
    ../vspec/bin/vspec test/basic.input ../vspec/ ../textobj-user/ .

Generating a vimball
--------------------

To distribute the script on [vim.org][s] wrap it up as a vimball by following these steps:

* open the file `vimballer` in Vim
* set the variable `g:vimball_home` to the development directory of this plugin (e.g. run: `:let g:vimball_home='~/dotfiles/vim/bundle/textobj-rubyblock'`)
* visually select all lines in `vimballer` file
* run `'<,'>MkVimball! textobj-rubyblock.vba`

That should create a file called `textobj-rubyblock.vba` which you can upload to [vim.org][s].

[u]: https://github.com/kana/vim-textobj-user
[vspec]: https://github.com/kana/vim-vspec
[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332
[s]: http://www.vim.org/scripts/index.php

Credits
=======

This plugin was built by [Drew Neil][me], but the real credit goes to [Kana][], whose [textobj-user][kana-git] plugin provides a framework for building custom text objects. I couldn't have created the rubyblock plugin without building on top of his hard work, so I'd like to say a big thanks to Kana.

[Kana]: http://whileimautomaton.net/
[textobj-user]: http://www.vim.org/scripts/script.php?script_id=2100
[kana-git]: https://github.com/kana/vim-textobj-user
[me]: http://drewneil.com
