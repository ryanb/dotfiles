This vim bundle adds syntax highlighting for [.less]. It's based on [leafo's vim resource][leafo]. This README is also heavily inspired by [vim-coffee-script].

[.less]: http://lesscss.org/
[leafo]: http://leafo.net/lessphp/vim/
[vim-coffee-script]: https://github.com/kchmck/vim-coffee-script

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

3. Make a clone of the `vim-less` repository:

        $ git clone git://github.com/lunaru/vim-less.git
        [...]
        $ ls
        vim-less/

That's it. Pathogen should handle the rest. Opening a file with a `.less`
extension will load everything.

### Updating

1. Change into the `~/.vim/bundle/vim-less/` directory:

        $ cd ~/.vim/bundle/vim-less

2. Pull in the latest changes:

        $ git pull

Everything will then be brought up to date.
