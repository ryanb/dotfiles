-- I use a set of plugins to provide language server support, which gives me
-- all sorts of good things:
--
-- * Great auto-completion
-- * Hover documentation (hit K to bring it up)
-- * Real-time errors and warnings
-- * Quick navigation to defitions and references
-- * Auto-formatting
--
-- The two key plugins are:
--
-- * nvim-lspconfig configures and runs language servers
-- * null-ls configures and runs formatters
--
-- Underlying this, I use mason to install all language servers and formatters.
--
-- A pair of plugins ties all this this together.
--
-- * mason-lspconfig ties nvim-lspconfig to mason
-- * mason-null-ls ties null-ls to mason

-- mason installs language servers and formatters.
--
-- It puts them in ~/.local/share/NVIM_APPNAME/mason, where NVIM_APPNAME
-- defaults to `nvim`.
local mason_spec = {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    build = function()
        -- After install, synchronously refresh the registry of packages so
        -- mason-lspconfig and mason-null-ls can install things.
        require("mason-registry").refresh()
    end,
    opts = { PATH = "append" },
}

-- mason-lspconfig uses mason to install language servers configured in
-- nvim-lspconfig.
--
-- It must be set up _before_ nvim-lspconfig, so the nvim-lspconfig spec must
-- depend on this one.
local mason_lspconfig_spec = {
    -- https://github.com/williamboman/mason-lspconfig.nvim
    "williamboman/mason-lspconfig.nvim",
    dependencies = { mason_spec },
    opts = { automatic_installation = true },
}

-- nvim-lspconfig configures neovim to talk to language servers.
local lspconfig_spec = {
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp", mason_lspconfig_spec },
    config = require("plugin-specs.lsp.lspconfig-config"),
}

-- null-ls auto-formats files on save.
--
-- You might notice we talk about null-ls, but the actual plugin is called
-- none-ls. Null-ls was abandoned by its creator, and none-ls is a community
-- supported fork.
local null_ls_spec = {
    -- https://github.com/nvimtools/none-ls.nvim
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = require("plugin-specs.lsp.null-ls-config"),
}

-- mason-null-ls uses mason to install formatters configured in null-ls.
--
-- It must be set up _after_ null-ls, so this spec must depend on the null-ls
-- spec.
local mason_null_ls_spec = {
    -- https://github.com/jay-babu/mason-null-ls.nvim
    "jay-babu/mason-null-ls.nvim",
    dependencies = { mason_spec, null_ls_spec },
    opts = {
        automatic_installation = true,
        -- The bashls lspconfig setup doesn't automatically install shellcheck,
        -- so install it here.
        ensure_installed = { "shellcheck" },
    },
}

return { lspconfig_spec, mason_null_ls_spec }
