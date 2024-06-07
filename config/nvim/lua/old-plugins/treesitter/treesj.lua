-- Split and join blocks of code
--
-- https://github.com/Wansmer/treesj

local treesitter_spec = require("plugin-specs.treesitter.treesitter-spec")

local opts = { use_default_keymaps = false }

return {
    "Wansmer/treesj",
    dependencies = { treesitter_spec },
    opts = opts,
}
