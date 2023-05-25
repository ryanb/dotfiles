return {
    configure = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.softtabstop = 2
        vim.opt.expandtab = true
        vim.opt.breakindent = true
        vim.opt.linebreak = true
        vim.opt.scrolloff = 2
        vim.opt.tildeop = true
        vim.opt.showmatch = true
        vim.opt.mouse = "a"

        -- Use relative line numbering, but display the actual line
        -- number on the current line, and highlight it.
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.cursorline = true
        vim.opt.cursorlineopt = "number"
    end
}
