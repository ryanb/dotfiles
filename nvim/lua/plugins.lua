local packadd = require("packadd")

local function configure_autoclosing()
    packadd("nvim-autopairs")
    local autopairs = require("nvim-autopairs")
    autopairs.setup({})

    packadd("nvim-ts-autotag")
    local autotag = require("nvim-ts-autotag")
    autotag.setup()
end

local function configure_autoformatting()
    packadd("neoformat")
    vim.g.neoformat_try_node_exe = true
end

local function configure_git_signs()
    packadd("gitsigns.nvim")
    local gitsigns = require("gitsigns")
    gitsigns.setup()
end

return {
    configure = function()
        configure_autoclosing()
        configure_autoformatting()
        configure_git_signs()
        packadd("vim-commentary")
        packadd("vim-rails")
    end
}
