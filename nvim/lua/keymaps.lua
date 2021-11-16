local function keymap_args(lhs, mapping)
  local mode = mapping.mode or 'n'
  local rhs =
    mapping.keys or
    (mapping.cmd and '<cmd>'..mapping.cmd..'<CR>') or
    (mapping.lua and '<cmd>lua '..mapping.lua..'<CR>')
  local opts = mapping.opts or { noremap = true, silent = true }
  return { mode, lhs, rhs, opts }
end

local function set_keymap(lhs, mapping)
  vim.api.nvim_set_keymap(unpack(keymap_args(lhs, mapping)))
end

local function buf_set_keymap(buffer_number, lhs, mapping)
  vim.api.nvim_buf_set_keymap(buffer_number, unpack(keymap_args(lhs, mapping)))
end

return {
  set = function(mappings)
    for lhs, mapping in pairs(mappings) do
      set_keymap(lhs, mapping)
    end
  end,

  buf_set = function(buffer_number, mappings)
    for lhs, mapping in pairs(mappings) do
      buf_set_keymap(buffer_number, lhs, mapping)
    end
  end
}
