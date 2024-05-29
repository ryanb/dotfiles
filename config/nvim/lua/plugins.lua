-- Install lazy.nvim from git if it's not already installed..
local function bootstrap()
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
end

-- Install and load all the plugins.
--
-- Pass in the colorscheme to use during installation. This does not set the
-- overall neovim colorscheme.
local function configure(colorscheme)
    bootstrap()

    require("lazy").setup({
        -- Don't notify whenever a config file changes. It's not helpful.
        change_detection = {
            enabled = true,
            notify = false,
        },
        spec = {
            -- Lazy will load every file in these directories.
            { import = "plugins.appearance" },
            { import = "plugins.completion" },
            { import = "plugins.editing" },
            { import = "plugins.languages" },
            { import = "plugins.lsp" },
            { import = "plugins.navigation" },
            { import = "plugins.treesitter" },
        },
        install = {
            -- Lazy tries to use this colorscheme during installation.
            colorscheme = { colorscheme },
        },
    })
end

return { configure = configure }
