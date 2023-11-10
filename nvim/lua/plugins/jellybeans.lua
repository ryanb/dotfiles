local packadd = require("helpers").packadd

local function configure()
    vim.opt.termguicolors = true

    packadd("jellybeans.vim") -- https://github.com/nanotech/jellybeans.vim

    -- Use the terminal's background instead of black.
    vim.g.jellybeans_overrides = {background = {guibg = "none"}}

    vim.cmd.colorscheme("jellybeans")
end

return {configure = configure}
