local function configure()
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
    vim.opt.autowriteall = true

    -- Use relative line numbering, but display the actual line
    -- number on the current line, and highlight it.
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.cursorlineopt = "number"

    -- Stop checkhealth complaining about missing language providers.
    -- I never use the language-specific interfaces anyway.
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0

    vim.api.nvim_create_augroup("fileTypeOptions", {clear = true})
    vim.api.nvim_create_autocmd(
        "FileType",
        {
            pattern = "lua",
            group = "fileTypeOptions",
            callback = function()
                vim.opt_local.tabstop = 4
                vim.opt_local.shiftwidth = 4
                vim.opt_local.softtabstop = 4
            end
        }
    )
end

return {configure = configure}
