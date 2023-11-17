local function configure()
    -- Need this set up before we load all the plugins.
    vim.g.mapleader = " "
    vim.o.termguicolors = true

    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.expandtab = true
    vim.o.breakindent = true
    vim.o.linebreak = true
    vim.o.scrolloff = 2
    vim.o.tildeop = true
    vim.o.showmatch = true
    vim.o.mouse = "a"
    vim.o.mousescroll = "ver:1"
    vim.o.autowriteall = true

    -- Use relative line numbering, but display the actual line
    -- number on the current line, and highlight it.
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.cursorline = true
    vim.o.cursorlineopt = "number"

    -- Don't show the default startup message.
    vim.opt.shortmess:append({ I = true })

    -- Get rid of the annoying ~ characters on empty lines.
    vim.opt.fillchars = { eob = " " }

    -- Stop checkhealth complaining about missing language providers.
    -- I never use the language-specific interfaces anyway.
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0

    local group = vim.api.nvim_create_augroup("fileTypeOptions", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        group = group,
        callback = function()
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
        end,
    })
end

return { configure = configure }
