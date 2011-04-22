" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:current_syntax")
  finish
endif

if version < 600
  syntax clear
endif

let b:current_syntax = "coffee"

" Highlight long strings.
syntax sync minlines=100

" CoffeeScript allows dollar signs in identifiers.
setlocal isident+=$

" These are 'matches' rather than 'keywords' because vim's highlighting priority
" for keywords (the highest) causes them to be wrongly highlighted when used as
" dot-properties.
syntax match coffeeStatement /\<\%(return\|break\|continue\|throw\)\>/
highlight default link coffeeStatement Statement

syntax match coffeeRepeat /\<\%(for\|while\|until\|loop\)\>/
highlight default link coffeeRepeat Repeat

syntax match coffeeConditional /\<\%(if\|else\|unless\|switch\|when\|then\)\>/
highlight default link coffeeConditional Conditional

syntax match coffeeException /\<\%(try\|catch\|finally\)\>/
highlight default link coffeeException Exception

syntax match coffeeOperator /\<\%(instanceof\|typeof\|delete\)\>/
highlight default link coffeeOperator Operator

syntax match coffeeKeyword /\<\%(new\|in\|of\|by\|and\|or\|not\|is\|isnt\|class\|extends\|super\|own\|do\)\>/
highlight default link coffeeKeyword Keyword

syntax match coffeeBoolean /\<\%(\%(true\|on\|yes\|false\|off\|no\)\)\>/
highlight default link coffeeBoolean Boolean

syntax match coffeeGlobal /\<\%(null\|undefined\)\>/
highlight default link coffeeGlobal Type

" Keywords reserved by the language
syntax cluster coffeeReserved contains=coffeeStatement,coffeeRepeat,
\                                      coffeeConditional,coffeeException,
\                                      coffeeOperator,coffeeKeyword,
\                                      coffeeBoolean,coffeeGlobal

syntax match coffeeVar /\<\%(this\|prototype\|arguments\)\>/
" Matches @-variables like @abc.
syntax match coffeeVar /@\%(\I\i*\)\?/
highlight default link coffeeVar Type

" Matches class-like names that start with a capital letter, like Array or
" Object.
syntax match coffeeObject /\<\u\w*\>/
highlight default link coffeeObject Structure

" Matches constant-like names in SCREAMING_CAPS.
syntax match coffeeConstant /\<\u[A-Z0-9_]\+\>/
highlight default link coffeeConstant Constant

" What can make up a variable name
syntax cluster coffeeIdentifier contains=coffeeVar,coffeeObject,coffeeConstant,
\                                        coffeePrototype

syntax region coffeeString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@coffeeInterpString
syntax region coffeeString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@coffeeSimpleString
highlight default link coffeeString String

syntax region coffeeAssignString start=/"/ skip=/\\\\\|\\"/ end=/"/ contained contains=@coffeeSimpleString
syntax region coffeeAssignString start=/'/ skip=/\\\\\|\\'/ end=/'/ contained contains=@coffeeSimpleString
highlight default link coffeeAssignString String

" Matches numbers like -10, -10e8, -10E8, 10, 10e8, 10E8.
syntax match coffeeNumber /\i\@<![-+]\?\d\+\%([eE][+-]\?\d\+\)\?/
" Matches hex numbers like 0xfff, 0x000.
syntax match coffeeNumber /\<0[xX]\x\+\>/
highlight default link coffeeNumber Number

" Matches floating-point numbers like -10.42e8, 10.42e-8.
syntax match coffeeFloat /\i\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/
highlight default link coffeeFloat Float

syntax match coffeeAssignSymbols /:\@<!::\@!\|++\|--\|\%(\%(\s\zs\%(and\|or\)\)\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!/ contained
highlight default link coffeeAssignSymbols SpecialChar

syntax match coffeeAssignBrackets /\[.\+\]/ contained contains=TOP,coffeeAssign

syntax match coffeeAssign /\%(++\|--\)\s*\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*/
\                         contains=@coffeeIdentifier,coffeeAssignSymbols,coffeeAssignBrackets
syntax match coffeeAssign /\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*\%(++\|--\|\s*\%(and\|or\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!\)/
\                         contains=@coffeeIdentifier,coffeeAssignSymbols,coffeeAssignBrackets

" Displays an error for reserved words.
if !exists("coffee_no_reserved_words_error")
  syntax match coffeeReservedError /\<\%(case\|default\|function\|var\|void\|with\|const\|let\|enum\|export\|import\|native\|__hasProp\|__extends\|__slice\|__bind\|__indexOf\)\>/
  highlight default link coffeeReservedError Error
endif

syntax match coffeeAssign /@\?\I\i*\s*:\@<!::\@!/ contains=@coffeeIdentifier,coffeeAssignSymbols
" Matches string assignments in object literals like {'a': 'b'}.
syntax match coffeeAssign /\("\|'\)[^\1]*\1\s*;\@<!::\@!/ contains=coffeeAssignString,
\                                                      coffeeAssignSymbols
" Matches number assignments in object literals like {42: 'a'}.
syntax match coffeeAssign /\d\+\%(\.\d\+\)\?\s*:\@<!::\@!/ contains=coffeeNumber,coffeeAssignSymbols
highlight default link coffeeAssign Identifier

syntax match coffeePrototype /::/
highlight default link coffeePrototype SpecialChar

syntax match coffeeFunction /->\|=>/
highlight default link coffeeFunction Function

syntax keyword coffeeTodo TODO FIXME XXX contained
highlight default link coffeeTodo Todo

syntax match coffeeComment /#.*/ contains=@Spell,coffeeTodo
syntax region coffeeComment start=/####\@!/ end=/###/ contains=@Spell,coffeeTodo
highlight default link coffeeComment Comment

syntax region coffeeHereComment start=/#/ end=/\ze\/\/\// end=/$/ contained contains=@Spell,coffeeTodo
highlight default link coffeeHereComment coffeeComment

syntax region coffeeEmbed start=/`/ skip=/\\\\\|\\`/ end=/`/
highlight default link coffeeEmbed Special

syntax region coffeeInterpolation matchgroup=coffeeInterpDelim
\                                 start=/\#{/ end=/}/
\                                 contained contains=TOP
highlight default link coffeeInterpDelim Delimiter

" Matches escape sequences like \000, \x00, \u0000, \n.
syntax match coffeeEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
highlight default link coffeeEscape SpecialChar

" What is in a non-interpolated string
syntax cluster coffeeSimpleString contains=@Spell,coffeeEscape
" What is in an interpolated string
syntax cluster coffeeInterpString contains=@coffeeSimpleString,
\                                           coffeeInterpolation

syntax region coffeeRegex start=/\%(\%()\|\i\@<!\d\)\s*\|\i\)\@<!\/\s\@!/
\                         skip=/\[[^]]\{-}\/[^]]\{-}\]/
\                         end=/\/[gimy]\{,4}\d\@!/
\                         oneline contains=@coffeeSimpleString
syntax region coffeeHereRegex start=/\/\/\// end=/\/\/\/[gimy]\{,4}/ contains=@coffeeInterpString,coffeeHereComment fold
highlight default link coffeeHereRegex coffeeRegex
highlight default link coffeeRegex String

syntax region coffeeHeredoc start=/"""/ end=/"""/ contains=@coffeeInterpString fold
syntax region coffeeHeredoc start=/'''/ end=/'''/ contains=@coffeeSimpleString fold
highlight default link coffeeHeredoc String

" Displays an error for trailing whitespace.
if !exists("coffee_no_trailing_space_error")
  syntax match coffeeSpaceError /\S\@<=\s\+$/ display
  highlight default link coffeeSpaceError Error
endif

" Displays an error for trailing semicolons.
if !exists("coffee_no_trailing_semicolon_error")
  syntax match coffeeSemicolonError /;$/ display
  highlight default link coffeeSemicolonError Error
endif

" Reserved words can be used as dot-properties.
syntax match coffeeDot /\.\@<!\.\i\+/ transparent
\                                     contains=ALLBUT,@coffeeReserved,
\                                                      coffeeReservedError
