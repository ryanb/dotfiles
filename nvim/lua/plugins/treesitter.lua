local packadd = require("helpers").packadd

local function configure()
    packadd("nvim-treesitter") -- https://github.com/nvim-treesitter/nvim-treesitter
    packadd("nvim-treesitter-textobjects") -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup(
        {
            ensure_installed = {
                "lua",
                "javascript",
                "typescript",
                "tsx",
                "css",
                "scss",
                "ruby"
            },
            highlight = {enable = true},
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner"
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {["]m"] = "@function.outer"},
                    goto_next_end = {["]M"] = "@function.outer"},
                    goto_previous_start = {["[m"] = "@function.outer"},
                    goto_previous_end = {["[M"] = "@function.outer"}
                }
            }
        }
    )

    -- Treesitter ain't got suppot for slim, so:
    packadd("vim-slim")
end

return {configure = configure}
