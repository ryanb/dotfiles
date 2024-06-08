-- Don't load all our plugins and stuff in VSCode.
if vim.g.vscode then
    return
end

local colorscheme = "nordfox"

-- These need to happen before plugins have loaded:
require("options").configure()

-- Install lazy.nvim from git if it's not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.notify("Installing lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Then we install and load the plugins.
require("lazy").setup({
    spec = {
        -- Load everything from the lua/plugins directory.
        import = "plugins",
    },
    change_detection = {
        -- Don't notify whenever a config file changes. It's not helpful.
        enabled = true,
        notify = false,
    },
    install = {
        -- Lazy tries to use this colorscheme during installation.
        colorscheme = { colorscheme },
    },
})

-- And these need to happen after the plugins have loaded:
vim.cmd.colorscheme(colorscheme)
require("key-mappings").configure()
