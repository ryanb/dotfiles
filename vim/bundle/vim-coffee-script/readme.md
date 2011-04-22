This project adds [CoffeeScript] support to the vim editor. Currently, it
supports [almost][todo] all of CoffeeScript's syntax and indentation style.

![Screenshot][screenshot]

[CoffeeScript]: http://coffeescript.org
[todo]: http://github.com/kchmck/vim-coffee-script/blob/master/todo.md
[screenshot]: http://i.imgur.com/xbto8.png

### Installing and Using

1. Install [tpope's][tpope] [pathogen] into `~/.vim/autoload/` and add the
   following line to your `~/.vimrc`:

        call pathogen#runtime_append_all_bundles()

     Be aware that it must be added before any `filetype plugin indent on`
     lines according to the install page:

     > Note that you need to invoke the pathogen functions before invoking
     > "filetype plugin indent on" if you want it to load ftdetect files. On
     > Debian (and probably other distros), the system vimrc does this early on,
     > so you actually need to "filetype off" before "filetype plugin indent on"
     > to force reloading.

[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332
[tpope]: http://github.com/tpope/vim-pathogen

2. Create, and change into, the `~/.vim/bundle/` directory:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle

3. Make a clone of the `vim-coffee-script` repository:

        $ git clone git://github.com/kchmck/vim-coffee-script.git
        [...]
        $ ls
        vim-coffee-script/

That's it. Pathogen should handle the rest. Opening a file with a `.coffee`
extension or a `Cakefile` will load everything.

### Updating

1. Change into the `~/.vim/bundle/vim-coffee-script/` directory:

        $ cd ~/.vim/bundle/vim-coffee-script

2. Pull in the latest changes:

        $ git pull

Everything will then be brought up to date.

### Compiling a CoffeeScript Snippet

The `CoffeeCompile` command can be used to peek at how the current file or a
snippet of CoffeeScript would be compiled to JavaScript. Calling `CoffeeCompile`
without a range compiles the entire file:

  ![CoffeeCompile](http://i.imgur.com/AZAAd.png)

and shows an output like:

  ![Compiled](http://i.imgur.com/5Huj4.png)

Calling `CoffeeCompile` with a range, like in visual mode, compiles the selected
snippet of CoffeeScript:

  ![CoffeeCompile Snippet](http://i.imgur.com/SKqCc.png)

and shows an output like:

  ![Compiled Snippet](http://i.imgur.com/wkO4f.png)

The command can also be mapped to a visual mode key for convenience:

    vmap KEY :CoffeeCompile<CR>

### Customizing

These customizations can be enabled or disabled by adding the relevant `let`
statement to your `~/.vimrc`.

#### Fold by indentation

Folding is automatically setup as indent-based:

  ![Folding](http://i.imgur.com/Cq9JA.png)

It's disabled by default, but can be enabled with:

    1et coffee_folding = 1

Otherwise, it can be quickly toggled per-file with the `zi` command.

#### Compile the current file on save

To compile the current file at each save, set:

    let coffee_compile_on_save = 1

This just calls `coffee -c` on the file, so make sure `coffee` is in your
`$PATH`. Currently, no compiler output or errors are shown.

#### Disable trailing whitespace error

Trailing whitespace is highlighted as an error by default. This can be disabled
with:

    let coffee_no_trailing_space_error = 1

#### Disable trailing semicolon error

Trailing semicolons are also considered an error. This can be disabled with:

    let coffee_no_trailing_semicolon_error = 1

#### Disable reserved words error

Reserved words such as `function` and `var` are highlighted an error in contexts
disallowed by CoffeeScript. This can be disabled with:

    let coffee_no_reserved_words_error = 1
