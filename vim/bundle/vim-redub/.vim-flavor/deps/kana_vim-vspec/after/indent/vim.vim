" Vim additional indent settings: vim/vspec - indent vspec commands
" Version: 1.1.2
" Copyright (C) 2012-2013 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

" NB: This file should be named after/indent/vim/vspec.vim, but unlike
" $VIMRUNTIME/ftplugin.vim, $VIMRUNTIME/indent.vim does not :runtime! neither
" indent/{filetype}_*.vim nor indent/{filetype}/*.vim.

let &l:indentexpr = 'GetVimVspecIndent(' . &l:indentexpr . ')'

if exists('*GetVimVspecIndent')
  finish
endif

function GetVimVspecIndent(base_indent)
  let indent = a:base_indent

  let base_lnum = prevnonblank(v:lnum - 1)
  let line = getline(base_lnum)
  if 0 <= match(line, '\(^\||\)\s*\(after\|before\|describe\|it\)\>')
    let indent += &l:shiftwidth
  endif

  return indent
endfunction

" __END__
" vim: foldmethod=marker
