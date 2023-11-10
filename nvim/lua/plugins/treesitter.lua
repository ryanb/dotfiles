local function configure()
    vim.cmd.packadd({"nvim-treesitter", bang = true}) -- https://github.com/nvim-treesitter/nvim-treesitter
    vim.cmd.packadd({"nvim-treesitter-textobjects", bang = true}) -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup(
        {
            ensure_installed = {
                "bash",
                "css",
                "graphql",
                "html",
                "javascript",
                "json",
                "jsonc",
                "lua",
                "ruby",
                "scss",
                "tsx",
                "typescript"
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
    vim.cmd.packadd({"vim-slim", bang = true}) -- https://github.com/tpope/vim-rails
end

return {configure = configure}
