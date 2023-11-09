local packadd = require("helpers/packadd")

local function configure_colors()
    vim.opt.termguicolors = true
    packadd("jellybeans.vim") -- https://github.com/nanotech/jellybeans.vim
    -- Use the terminal's background instead of black.
    vim.g.jellybeans_overrides = {background = {guibg = "none"}}
    vim.cmd.colorscheme("jellybeans")
end

local function configure_icons()
    -- Used for telescope, nvim-tree, and lualine
    packadd("nvim-web-devicons") -- https://github.com/nvim-tree/nvim-web-devicons
    local devicons = require("nvim-web-devicons")
    devicons.setup({default = true})
end

local function configure_status_line()
    packadd("lualine.nvim") -- https://github.com/nvim-lualine/lualine.nvim
    local lualine = require("lualine")
    lualine.setup({options = {theme = "auto"}})
    vim.opt.showmode = false -- Lualine shows the mode for us.
    vim.opt.laststatus = 3 -- Use a full-width status line.
end

local function configure_git_signs()
    packadd("gitsigns.nvim") -- https://github.com/lewis6991/gitsigns.nvim
    local gitsigns = require("gitsigns")
    gitsigns.setup()
end

return {
    configure = function()
        configure_colors()
        configure_icons()
        configure_status_line()
        configure_git_signs()
    end
}
