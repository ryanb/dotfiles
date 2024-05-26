-- Set my preferred neovim options.
local function configure()
    -- Allow loading config from the current directory.
    -- Since neovim 0.9, this has been made pretty secure.
    vim.o.exrc = true

    -- Use space as the leader key. Needs to be set before we load plugins.
    vim.g.mapleader = " "

    -- Default to 2 space indents.
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.expandtab = true

    -- Make lines wrap at word boundaries and indent the wrapped text.
    vim.o.breakindent = true
    vim.o.linebreak = true

    -- Use the mouse for everything and slow down the scroll wheel.
    vim.o.mouse = "a"
    vim.o.mousescroll = "ver:1"

    -- Use relative line numbering, but display the actual line
    -- number on the current line, and highlight it.
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.cursorline = true
    vim.o.cursorlineopt = "number"

    vim.opt.shortmess:append({
        I = true, -- Don't show the default startup message.
        S = true, -- Hide the search count, because lualine shows it for us.
    })

    -- Get rid of the annoying ~ characters on empty lines.
    vim.opt.fillchars = { eob = " " }

    -- Other bits and pieces.
    vim.o.autowriteall = true
    vim.o.scrolloff = 5
    vim.o.showcmd = false
    vim.o.showmatch = true
    vim.o.showmode = false
    vim.o.signcolumn = "yes"
    vim.o.tildeop = true

    -- Stop checkhealth complaining about missing language providers.
    -- I never use the language-specific interfaces anyway.
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
end

return { configure = configure }
