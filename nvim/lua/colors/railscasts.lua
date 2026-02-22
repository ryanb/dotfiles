-- Railscasts colorscheme - exact colors from VS Code theme
local M = {}

local colors = {
  bg = '#282828',
  fg = '#E6E1DC',
  line_highlight = '#333435',
  selection = '#3D4456',
  cursor = '#FFFFFF',
  whitespace = '#404040',
  comment = '#BC9458',
  keyword = '#CC7833',
  func_def = '#FFC66D',
  class_def = '#FFFFFF',
  number = '#A5C261',
  variable = '#D0D0FF',
  constant = '#6D9CBE',
  constant_other = '#DA4939',
  string = '#A5C261',
  string_escape = '#519F50',
  tag = '#E8BF6A',
  invalid_bg = '#990000',
  diff_add_bg = '#144212',
  diff_remove_bg = '#660000',
  diff_header_bg = '#2F33AB',
  erb_bg = '#1F1F1F',
  -- Additional UI colors derived from theme
  visual = '#3D4456',
  search = '#5A5A00',
  inc_search = '#E8BF6A',
  pmenu_bg = '#333435',
  pmenu_sel = '#3D4456',
  error = '#DA4939',
  warning = '#E8BF6A',
  info = '#6D9CBE',
  hint = '#A5C261',
}

function M.setup()
  -- Reset all highlighting
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end
  vim.o.background = 'dark'
  vim.g.colors_name = 'railscasts'

  local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Editor UI
  hi('Normal', { fg = colors.fg, bg = colors.bg })
  hi('NormalFloat', { fg = colors.fg, bg = colors.pmenu_bg })
  hi('FloatBorder', { fg = colors.comment, bg = colors.pmenu_bg })
  hi('Cursor', { fg = colors.bg, bg = colors.cursor })
  hi('CursorLine', { bg = colors.line_highlight })
  hi('CursorColumn', { bg = colors.line_highlight })
  hi('ColorColumn', { bg = colors.line_highlight })
  hi('LineNr', { fg = colors.whitespace })
  hi('CursorLineNr', { fg = colors.fg, bold = true })
  hi('SignColumn', { fg = colors.fg, bg = colors.bg })
  hi('VertSplit', { fg = colors.whitespace, bg = colors.bg })
  hi('WinSeparator', { fg = colors.whitespace, bg = colors.bg })
  hi('Folded', { fg = colors.comment, bg = colors.line_highlight, italic = true })
  hi('FoldColumn', { fg = colors.whitespace, bg = colors.bg })
  hi('NonText', { fg = colors.whitespace })
  hi('SpecialKey', { fg = colors.whitespace })
  hi('Whitespace', { fg = colors.whitespace })
  hi('EndOfBuffer', { fg = colors.whitespace })

  -- Selection and Search
  hi('Visual', { bg = colors.visual })
  hi('VisualNOS', { bg = colors.visual })
  hi('Search', { fg = colors.bg, bg = colors.inc_search })
  hi('IncSearch', { fg = colors.bg, bg = colors.inc_search })
  hi('CurSearch', { fg = colors.bg, bg = colors.inc_search })
  hi('Substitute', { fg = colors.bg, bg = colors.constant_other })

  -- Popup Menu
  hi('Pmenu', { fg = colors.fg, bg = colors.pmenu_bg })
  hi('PmenuSel', { fg = colors.fg, bg = colors.pmenu_sel })
  hi('PmenuSbar', { bg = colors.pmenu_bg })
  hi('PmenuThumb', { bg = colors.whitespace })

  -- Messages
  hi('ErrorMsg', { fg = colors.error, bold = true })
  hi('WarningMsg', { fg = colors.warning, bold = true })
  hi('ModeMsg', { fg = colors.fg, bold = true })
  hi('MoreMsg', { fg = colors.string })
  hi('Question', { fg = colors.string })

  -- Tabs
  hi('TabLine', { fg = colors.comment, bg = colors.line_highlight })
  hi('TabLineFill', { bg = colors.bg })
  hi('TabLineSel', { fg = colors.fg, bg = colors.bg, bold = true })

  -- Status Line
  hi('StatusLine', { fg = colors.fg, bg = colors.line_highlight })
  hi('StatusLineNC', { fg = colors.comment, bg = colors.line_highlight })

  -- Syntax Highlighting
  hi('Comment', { fg = colors.comment, italic = true })
  hi('String', { fg = colors.string })
  hi('Character', { fg = colors.string })
  hi('Number', { fg = colors.number })
  hi('Boolean', { fg = colors.constant })
  hi('Float', { fg = colors.number })

  hi('Identifier', { fg = colors.fg })
  hi('Function', { fg = colors.func_def })

  hi('Statement', { fg = colors.keyword })
  hi('Conditional', { fg = colors.keyword })
  hi('Repeat', { fg = colors.keyword })
  hi('Label', { fg = colors.keyword })
  hi('Operator', { fg = colors.fg })
  hi('Keyword', { fg = colors.keyword })
  hi('Exception', { fg = colors.keyword })

  hi('PreProc', { fg = colors.keyword })
  hi('Include', { fg = colors.keyword })
  hi('Define', { fg = colors.keyword })
  hi('Macro', { fg = colors.keyword })
  hi('PreCondit', { fg = colors.keyword })

  hi('Type', { fg = colors.constant })
  hi('StorageClass', { fg = colors.keyword })
  hi('Structure', { fg = colors.keyword })
  hi('Typedef', { fg = colors.keyword })

  hi('Special', { fg = colors.string_escape })
  hi('SpecialChar', { fg = colors.string_escape })
  hi('Tag', { fg = colors.tag })
  hi('Delimiter', { fg = colors.fg })
  hi('SpecialComment', { fg = colors.comment, italic = true })
  hi('Debug', { fg = colors.constant_other })

  hi('Underlined', { fg = colors.constant, underline = true })
  hi('Ignore', { fg = colors.whitespace })
  hi('Error', { fg = colors.cursor, bg = colors.invalid_bg })
  hi('Todo', { fg = colors.tag, bold = true })

  hi('Constant', { fg = colors.constant })

  -- Diff
  hi('DiffAdd', { fg = colors.fg, bg = colors.diff_add_bg })
  hi('DiffChange', { fg = colors.fg, bg = colors.diff_header_bg })
  hi('DiffDelete', { fg = colors.fg, bg = colors.diff_remove_bg })
  hi('DiffText', { fg = colors.fg, bg = colors.diff_header_bg, bold = true })
  hi('Added', { fg = colors.string })
  hi('Changed', { fg = colors.constant })
  hi('Removed', { fg = colors.constant_other })

  -- Spelling
  hi('SpellBad', { undercurl = true, sp = colors.error })
  hi('SpellCap', { undercurl = true, sp = colors.warning })
  hi('SpellLocal', { undercurl = true, sp = colors.info })
  hi('SpellRare', { undercurl = true, sp = colors.hint })

  -- Diagnostics
  hi('DiagnosticError', { fg = colors.error })
  hi('DiagnosticWarn', { fg = colors.warning })
  hi('DiagnosticInfo', { fg = colors.info })
  hi('DiagnosticHint', { fg = colors.hint })
  hi('DiagnosticUnderlineError', { undercurl = true, sp = colors.error })
  hi('DiagnosticUnderlineWarn', { undercurl = true, sp = colors.warning })
  hi('DiagnosticUnderlineInfo', { undercurl = true, sp = colors.info })
  hi('DiagnosticUnderlineHint', { undercurl = true, sp = colors.hint })
  hi('DiagnosticVirtualTextError', { fg = colors.error, bg = colors.line_highlight })
  hi('DiagnosticVirtualTextWarn', { fg = colors.warning, bg = colors.line_highlight })
  hi('DiagnosticVirtualTextInfo', { fg = colors.info, bg = colors.line_highlight })
  hi('DiagnosticVirtualTextHint', { fg = colors.hint, bg = colors.line_highlight })

  -- Treesitter
  hi('@comment', { link = 'Comment' })
  hi('@string', { link = 'String' })
  hi('@string.escape', { fg = colors.string_escape })
  hi('@string.special', { fg = colors.string_escape })
  hi('@character', { link = 'Character' })
  hi('@number', { link = 'Number' })
  hi('@boolean', { link = 'Boolean' })
  hi('@float', { link = 'Float' })

  hi('@function', { fg = colors.fg })
  hi('@function.call', { fg = colors.fg })
  hi('@function.builtin', { fg = colors.fg })
  hi('@function.method', { fg = colors.fg })
  hi('@function.method.call', { fg = colors.fg })

  hi('@method', { fg = colors.fg })
  hi('@method.call', { fg = colors.fg })

  hi('@constructor', { fg = colors.class_def })
  hi('@parameter', { fg = colors.fg })

  hi('@keyword', { fg = colors.keyword })
  hi('@keyword.function', { fg = colors.keyword })
  hi('@keyword.operator', { fg = colors.keyword })
  hi('@keyword.return', { fg = colors.keyword })
  hi('@keyword.conditional', { fg = colors.keyword })
  hi('@keyword.repeat', { fg = colors.keyword })
  hi('@keyword.import', { fg = colors.keyword })
  hi('@keyword.exception', { fg = colors.keyword })

  hi('@conditional', { fg = colors.keyword })
  hi('@repeat', { fg = colors.keyword })
  hi('@label', { fg = colors.keyword })
  hi('@include', { fg = colors.keyword })
  hi('@exception', { fg = colors.keyword })

  hi('@operator', { fg = colors.fg })
  hi('@punctuation', { fg = colors.fg })
  hi('@punctuation.bracket', { fg = colors.fg })
  hi('@punctuation.delimiter', { fg = colors.fg })
  hi('@punctuation.special', { fg = colors.string_escape })

  hi('@type', { fg = colors.class_def })
  hi('@type.builtin', { fg = colors.constant })
  hi('@type.definition', { fg = colors.class_def })

  hi('@storageclass', { fg = colors.keyword })
  hi('@structure', { fg = colors.keyword })
  hi('@namespace', { fg = colors.constant_other })
  hi('@module', { fg = colors.constant_other })

  hi('@variable', { fg = colors.variable })
  hi('@variable.builtin', { fg = colors.variable })
  hi('@variable.parameter', { fg = colors.fg })
  hi('@variable.member', { fg = colors.fg })

  hi('@constant', { fg = colors.constant })
  hi('@constant.builtin', { fg = colors.constant })
  hi('@constant.macro', { fg = colors.constant })

  hi('@property', { fg = colors.fg })
  hi('@field', { fg = colors.fg })
  hi('@attribute', { fg = colors.tag })

  hi('@tag', { fg = colors.tag })
  hi('@tag.attribute', { fg = colors.tag })
  hi('@tag.delimiter', { fg = colors.fg })

  hi('@text', { fg = colors.fg })
  hi('@text.strong', { bold = true })
  hi('@text.emphasis', { italic = true })
  hi('@text.underline', { underline = true })
  hi('@text.strike', { strikethrough = true })
  hi('@text.title', { fg = colors.class_def, bold = true })
  hi('@text.literal', { fg = colors.string })
  hi('@text.uri', { fg = colors.constant, underline = true })
  hi('@text.reference', { fg = colors.constant })

  hi('@markup.heading', { fg = colors.class_def, bold = true })
  hi('@markup.strong', { bold = true })
  hi('@markup.italic', { italic = true })
  hi('@markup.link', { fg = colors.constant })
  hi('@markup.link.url', { fg = colors.constant, underline = true })
  hi('@markup.raw', { fg = colors.string })

  -- LSP Semantic Tokens
  hi('@lsp.type.class', { fg = colors.class_def })
  hi('@lsp.type.decorator', { fg = colors.tag })
  hi('@lsp.type.enum', { fg = colors.class_def })
  hi('@lsp.type.enumMember', { fg = colors.constant })
  hi('@lsp.type.function', { fg = colors.fg })
  hi('@lsp.type.interface', { fg = colors.class_def })
  hi('@lsp.type.method', { fg = colors.fg })
  hi('@lsp.type.namespace', { fg = colors.constant_other })
  hi('@lsp.type.parameter', { fg = colors.fg })
  hi('@lsp.type.property', { fg = colors.fg })
  hi('@lsp.type.struct', { fg = colors.class_def })
  hi('@lsp.type.type', { fg = colors.class_def })
  hi('@lsp.type.typeParameter', { fg = colors.class_def })
  hi('@lsp.type.variable', { fg = colors.variable })
  hi('@lsp.mod.declaration', { fg = colors.func_def })
  hi('@lsp.typemod.function.declaration', { fg = colors.func_def })
  hi('@lsp.typemod.method.declaration', { fg = colors.func_def })

  -- Git Signs
  hi('GitSignsAdd', { fg = colors.string })
  hi('GitSignsChange', { fg = colors.constant })
  hi('GitSignsDelete', { fg = colors.constant_other })

  -- Telescope
  hi('TelescopeNormal', { fg = colors.fg, bg = colors.bg })
  hi('TelescopeBorder', { fg = colors.comment, bg = colors.bg })
  hi('TelescopePromptNormal', { fg = colors.fg, bg = colors.line_highlight })
  hi('TelescopePromptBorder', { fg = colors.comment, bg = colors.line_highlight })
  hi('TelescopePromptTitle', { fg = colors.bg, bg = colors.keyword })
  hi('TelescopePreviewTitle', { fg = colors.bg, bg = colors.string })
  hi('TelescopeResultsTitle', { fg = colors.bg, bg = colors.constant })
  hi('TelescopeSelection', { fg = colors.fg, bg = colors.selection })
  hi('TelescopeMatching', { fg = colors.tag, bold = true })

  -- Which-key
  hi('WhichKey', { fg = colors.func_def })
  hi('WhichKeyGroup', { fg = colors.constant })
  hi('WhichKeyDesc', { fg = colors.fg })
  hi('WhichKeySeparator', { fg = colors.comment })
  hi('WhichKeyFloat', { bg = colors.pmenu_bg })

  -- Lazy
  hi('LazyButton', { fg = colors.fg, bg = colors.line_highlight })
  hi('LazyButtonActive', { fg = colors.bg, bg = colors.keyword })
  hi('LazyH1', { fg = colors.bg, bg = colors.keyword, bold = true })
  hi('LazySpecial', { fg = colors.constant })

  -- Mini
  hi('MiniStatuslineFilename', { fg = colors.fg, bg = colors.line_highlight })
  hi('MiniStatuslineDevinfo', { fg = colors.fg, bg = colors.pmenu_sel })
  hi('MiniStatuslineModeNormal', { fg = colors.bg, bg = colors.constant, bold = true })
  hi('MiniStatuslineModeInsert', { fg = colors.bg, bg = colors.string, bold = true })
  hi('MiniStatuslineModeVisual', { fg = colors.bg, bg = colors.keyword, bold = true })
  hi('MiniStatuslineModeReplace', { fg = colors.bg, bg = colors.constant_other, bold = true })
  hi('MiniStatuslineModeCommand', { fg = colors.bg, bg = colors.tag, bold = true })

  -- Blink CMP
  hi('BlinkCmpMenu', { fg = colors.fg, bg = colors.pmenu_bg })
  hi('BlinkCmpMenuBorder', { fg = colors.comment, bg = colors.pmenu_bg })
  hi('BlinkCmpMenuSelection', { bg = colors.pmenu_sel })
  hi('BlinkCmpLabel', { fg = colors.fg })
  hi('BlinkCmpLabelMatch', { fg = colors.tag, bold = true })
  hi('BlinkCmpKind', { fg = colors.constant })
  hi('BlinkCmpDoc', { fg = colors.fg, bg = colors.pmenu_bg })
  hi('BlinkCmpDocBorder', { fg = colors.comment, bg = colors.pmenu_bg })

  -- Match paren
  hi('MatchParen', { fg = colors.tag, bold = true })

  -- Directory
  hi('Directory', { fg = colors.constant })

  -- Title
  hi('Title', { fg = colors.class_def, bold = true })

  -- WildMenu
  hi('WildMenu', { fg = colors.bg, bg = colors.tag })
end

return M
