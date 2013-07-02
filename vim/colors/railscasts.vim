" Vim color scheme based on http://github.com/jpo/vim-railscasts-theme
"
" Name:        railscasts.vim
" Maintainer:  Ryan Bates
" License:     MIT

if &t_Co != 256 && ! has("gui_running")
	echomsg ""
	echomsg "err: please use GUI or a 256-color terminal (so that t_Co=256 could be set)"
	echomsg ""
	finish
endif

set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "railscasts"

" Colors
" Brown        #BC9357
" Dark Blue    #6D9CBD
" Dark Green   #509E50
" Dark Orange  #CC7733
" Light Blue   #CFCFFF
" Light Green  #A5C160
" Tan          #FFC66D
" Red          #DA4938 

hi Normal     ctermfg=188 guifg=#E6E1DC ctermbg=16 guibg=#232323
hi Cursor     ctermbg=231 guibg=#FFFFFF
hi CursorLine ctermbg=59 guibg=#333435
hi LineNr     ctermfg=59 guifg=#666666
hi Visual     ctermbg=60 guibg=#5A647E
hi Search     ctermfg=NONE    guifg=NONE    ctermbg=16 guibg=#131313  gui=NONE
hi Folded     ctermfg=230 guifg=#F6F3E8 ctermbg=59 guibg=#444444  gui=NONE
hi Directory  ctermfg=143 guifg=#A5C160 gui=NONE
hi Error      ctermfg=255 guifg=#FFFFFF ctermbg=88 guibg=#990000
hi MatchParen ctermfg=NONE    guifg=NONE    ctermbg=16 guibg=#131313
hi Title      ctermfg=188 guifg=#E6E1DC

hi Comment    ctermfg=137 guifg=#BC9357 ctermbg=NONE    guibg=NONE     gui=italic
hi! link Todo Comment

hi String     ctermfg=143 guifg=#A5C160
hi! link Number String
hi! link rubyStringDelimiter String

" nil, self, symbols
hi Constant ctermfg=73 guifg=#6D9CBD

" def, end, include, load, require, alias, super, yield, lambda, proc
hi Define ctermfg=173 guifg=#CC7733 gui=NONE
hi! link Include Define
hi! link Keyword Define
hi! link Macro Define

" #{foo}, <%= bar %>
hi Delimiter ctermfg=71 guifg=#509E50
" hi erubyDelimiter guifg=NONE

" function name (after def)
hi Function ctermfg=221 guifg=#FFC66D gui=NONE

"@var, @@var, $var
hi Identifier ctermfg=189 guifg=#CFCFFF gui=NONE

" #if, #else, #endif

" case, begin, do, for, if, unless, while, until, else
hi Statement ctermfg=173 guifg=#CC7733 gui=NONE
hi! link PreProc Statement
hi! link PreCondit Statement

" SomeClassName
hi Type ctermfg=NONE guifg=NONE gui=NONE

" has_many, respond_to, params
hi railsMethod ctermfg=167 guifg=#DA4938 gui=NONE

hi DiffAdd ctermfg=188 guifg=#E6E1DC ctermbg=22 guibg=#144212
hi DiffDelete ctermfg=188 guifg=#E6E1DC ctermbg=52 guibg=#660000

hi xmlTag ctermfg=179 guifg=#E8BF6A
hi! link xmlTagName  xmlTag
hi! link xmlEndTag   xmlTag
hi! link xmlArg      xmlTag
hi! link htmlTag     xmlTag
hi! link htmlTagName xmlTagName
hi! link htmlEndTag  xmlEndTag
hi! link htmlArg     xmlArg

" Popup Menu
" ----------
" normal item in popup
hi Pmenu ctermfg=230 guifg=#F6F3E8 ctermbg=59 guibg=#444444 gui=NONE
" selected item in popup
hi PmenuSel ctermfg=0 guifg=#000000 ctermbg=143 guibg=#A5C160 gui=NONE
" scrollbar in popup
hi PMenuSbar ctermbg=60 guibg=#5A647E gui=NONE
" thumb of the scrollbar in the popup
hi PMenuThumb ctermbg=145 guibg=#AAAAAA gui=NONE


