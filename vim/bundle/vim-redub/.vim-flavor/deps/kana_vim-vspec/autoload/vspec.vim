" vspec - Testing framework for Vim script
" Version: 1.1.2
" Copyright (C) 2009-2013 Kana Natsuno <http://whileimautomaton.net/>
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
" Constants  "{{{1
" Fundamentals  "{{{2

let s:FALSE = 0
let s:TRUE = !0








" Variables  "{{{1
let s:all_suites = []  "{{{2
" :: [Suite]




let s:current_suites = []  "{{{2
" :: [Suite]
" The stack to manage the currently active suite while running all suites.




let s:custom_matchers = {}  "{{{2
" :: MatcherNameString -> Matcher




let s:expr_hinted_scope = 's:fail("Scope hint is not given")'  "{{{2
" An expression which is evaluated to a script-local scope for Ref()/Set().




let s:expr_hinted_sid = 's:fail("SID hint is not given")'  "{{{2
" An expression which is evaluated to a <SID> for Call().




let s:saved_scope = {}  "{{{2
" A snapshot of a script-local variables for :SaveContext/:ResetContext.




let s:suite = {}  "{{{2
" The prototype for suites.








" Interface  "{{{1
" :Expect  "{{{2
command! -complete=expression -nargs=+ Expect
\ call s:cmd_Expect(
\   s:parse_should_arguments(<q-args>, 'raw'),
\   map(s:parse_should_arguments(<q-args>, 'eval'), 'eval(v:val)')
\ )




" :ResetContext  "{{{2
command! -bar -nargs=0 ResetContext
\ call s:cmd_ResetContext()




" :SaveContext  "{{{2
command! -bar -nargs=0 SaveContext
\ call s:cmd_SaveContext()




" :SKIP  "{{{2
command! -bar -nargs=+ SKIP
\ throw 'vspec:ExpectationFailure:SKIP:' . string({'message': <q-args>})




" :TODO  "{{{2
command! -bar -nargs=0 TODO
\ throw 'vspec:ExpectationFailure:TODO:' . string({})




function! Call(...)  "{{{2
  return call('vspec#call', a:000)
endfunction




function! Ref(...)  "{{{2
  return call('vspec#ref', a:000)
endfunction




function! Set(...)  "{{{2
  return call('vspec#set', a:000)
endfunction




function! vspec#call(function_name, ...)  "{{{2
  return call(substitute(a:function_name, '^s:', s:get_hinted_sid(), ''), a:000)
endfunction




function! vspec#customize_matcher(matcher_name, maybe_matcher)  "{{{2
  if type(a:maybe_matcher) == type({})
    let matcher = a:maybe_matcher
  else
    let matcher = {'match': a:maybe_matcher}
  endif
  let s:custom_matchers[a:matcher_name] = matcher
endfunction




function! vspec#hint(info)  "{{{2
  if has_key(a:info, 'scope')
    let s:expr_hinted_scope = a:info.scope
    call s:cmd_SaveContext()
  endif

  if has_key(a:info, 'sid')
    let s:expr_hinted_sid = a:info.sid
  endif
endfunction




function! vspec#ref(variable_name)  "{{{2
  if a:variable_name =~# '^s:'
    return s:get_hinted_scope()[a:variable_name[2:]]
  else
    throw 'vspec:InvalidOperation:Invalid variable_name - '
    \     . string(a:variable_name)
  endif
endfunction




function! vspec#set(variable_name, value)  "{{{2
  if a:variable_name =~# '^s:'
    let _ = s:get_hinted_scope()
    let _[a:variable_name[2:]] = a:value
  else
    throw 'vspec:InvalidOperation:Invalid variable_name - '
    \     . string(a:variable_name)
  endif
endfunction




function! vspec#test(specfile_path)  "{{{2
  let compiled_specfile_path = tempname()
  call s:compile_specfile(a:specfile_path, compiled_specfile_path)

  try
    execute 'source' compiled_specfile_path
  catch
    echo '#' v:throwpoint
    echo '#' v:exception
    let s:all_suites = []
  endtry

  let example_count = 0
  for suite in s:all_suites
    call s:push_current_suite(suite)
      for example in suite.example_list
        let example_count += 1
        call suite.before_block()
        try
          call suite.example_dict[suite.generate_example_function_name(example)]()
          echo printf(
          \   '%s %d - %s %s',
          \   'ok',
          \   example_count,
          \   suite.subject,
          \   example
          \ )
        catch /^vspec:/
          if v:exception =~# '^vspec:ExpectationFailure:'
            let xs = matchlist(v:exception, '^vspec:ExpectationFailure:\(\a\+\):\(.*\)$')
            let type = xs[1]
            let i = eval(xs[2])
            if type ==# 'MismatchedValues'
              echo printf(
              \   '%s %d - %s %s',
              \   'not ok',
              \   example_count,
              \   suite.subject,
              \   example
              \ )
              echo '# Expected' join(filter([
              \   i.expr_actual,
              \   i.expr_not,
              \   i.expr_matcher,
              \   i.expr_expected,
              \ ], 'v:val != ""'))
              for line in s:generate_failure_message(i)
                echo '#     ' . line
              endfor
            elseif type ==# 'TODO'
              echo printf(
              \   '%s %d - # TODO %s %s',
              \   'not ok',
              \   example_count,
              \   suite.subject,
              \   example
              \ )
            elseif type ==# 'SKIP'
              echo printf(
              \   '%s %d - # SKIP %s %s - %s',
              \   'ok',
              \   example_count,
              \   suite.subject,
              \   example,
              \   i.message
              \ )
            else
              echo printf(
              \   '%s %d - %s %s',
              \   'not ok',
              \   example_count,
              \   suite.subject,
              \   example
              \ )
              echo '#' substitute(v:exception, '^vspec:', '', '')
            endif
          else
            echo printf(
            \   '%s %d - %s %s',
            \   'not ok',
            \   example_count,
            \   suite.subject,
            \   example
            \ )
            echo '#' substitute(v:exception, '^vspec:', '', '')
          endif
        catch
          echo printf(
          \   '%s %d - %s %s',
          \   'not ok',
          \   example_count,
          \   suite.subject,
          \   example
          \ )
          echo '#' v:throwpoint
          echo '#' v:exception
        endtry
        call suite.after_block()
      endfor
    call s:pop_current_suite()
  endfor
  echo printf('1..%d', example_count)
  echo ''

  call delete(compiled_specfile_path)
endfunction




" Predefined custom matchers - to_be_false  "{{{2
function! vspec#_matcher_false(value)
  return type(a:value) == type(0) ? !(a:value) : s:FALSE
endfunction
call vspec#customize_matcher('to_be_false', function('vspec#_matcher_false'))
call vspec#customize_matcher('toBeFalse', function('vspec#_matcher_false'))




" Predefined custom matchers - to_be_true  "{{{2
function! vspec#_matcher_true(value)
  return type(a:value) == type(0) ? !!(a:value) : s:FALSE
endfunction
call vspec#customize_matcher('to_be_true', function('vspec#_matcher_true'))
call vspec#customize_matcher('toBeTrue', function('vspec#_matcher_true'))








" Suites  "{{{1
function! s:suite.add_example(example_description)  "{{{2
  call add(self.example_list, a:example_description)
endfunction




function! s:suite.after_block()  "{{{2
  " No-op to avoid null checks.
endfunction




function! s:suite.before_block()  "{{{2
  " No-op to avoid null checks.
endfunction




function! s:suite.generate_example_function_name(example_description)  "{{{2
  return substitute(
  \   a:example_description,
  \   '[^[:alnum:]]',
  \   '\="_" . printf("%02x", char2nr(submatch(0)))',
  \   'g'
  \ )
endfunction




function! s:get_current_suite()  "{{{2
  return s:current_suites[0]
endfunction




function! s:pop_current_suite()  "{{{2
  return remove(s:current_suites, 0)
endfunction




function! s:push_current_suite(suite)  "{{{2
  call insert(s:current_suites, a:suite, 0)
endfunction




function! vspec#add_suite(suite)  "{{{2
  call add(s:all_suites, a:suite)
endfunction




function! vspec#new_suite(subject)  "{{{2
  let s = copy(s:suite)

  let s.subject = a:subject  " :: SubjectString
  let s.example_list = []  " :: [DescriptionString]
  let s.example_dict = {}  " :: DescriptionString -> ExampleFuncref

  return s
endfunction








" Compiler  "{{{1
function! s:compile_specfile(specfile_path, result_path)  "{{{2
  let slines = readfile(a:specfile_path)
  let rlines = s:translate_script(slines)
  call writefile(rlines, a:result_path)
endfunction




function! s:translate_script(slines)  "{{{2
  let rlines = []
  let stack = []

  for sline in a:slines
    let tokens = matchlist(sline, '^\s*describe\s*\(''.*''\)\s*$')
    if !empty(tokens)
      call insert(stack, 'describe', 0)
      call extend(rlines, [
      \   printf('let suite = vspec#new_suite(%s)', tokens[1]),
      \   'call vspec#add_suite(suite)',
      \ ])
      continue
    endif

    let tokens = matchlist(sline, '^\s*it\s*\(''.*''\)\s*$')
    if !empty(tokens)
      call insert(stack, 'it', 0)
      call extend(rlines, [
      \   printf('call suite.add_example(%s)', tokens[1]),
      \   printf('function! suite.example_dict[suite.generate_example_function_name(%s)]()', tokens[1]),
      \ ])
      continue
    endif

    let tokens = matchlist(sline, '^\s*before\s*$')
    if !empty(tokens)
      call insert(stack, 'before', 0)
      call extend(rlines, [
      \   'function! suite.before_block()',
      \ ])
      continue
    endif

    let tokens = matchlist(sline, '^\s*after\s*$')
    if !empty(tokens)
      call insert(stack, 'after', 0)
      call extend(rlines, [
      \   'function! suite.after_block()',
      \ ])
      continue
    endif

    let tokens = matchlist(sline, '^\s*end\s*$')
    if !empty(tokens)
      let type = remove(stack, 0)
      if type ==# 'describe'
        " Nothing to do.
      elseif type ==# 'it'
        call extend(rlines, [
        \   'endfunction',
        \ ])
      elseif type ==# 'before'
        call extend(rlines, [
        \   'endfunction',
        \ ])
      elseif type ==# 'after'
        call extend(rlines, [
        \   'endfunction',
        \ ])
      else
        " Nothing to do.
      endif
      continue
    endif

    call add(rlines, sline)
  endfor

  return rlines
endfunction








" :Expect magic  "{{{1
function! s:cmd_Expect(exprs, vals)  "{{{2
  let d = {}
  let [d.expr_actual, d.expr_not, d.expr_matcher, d.expr_expected] = a:exprs
  let [d.value_actual, d.value_not, d.value_matcher, d.value_expected] = a:vals

  let truth = d.value_not ==# ''
  if truth != s:are_matched(d.value_actual, d.value_matcher, d.value_expected)
    throw 'vspec:ExpectationFailure:MismatchedValues:' . string(d)
  endif
endfunction




function! s:parse_should_arguments(s, mode)  "{{{2
  let tokens = s:split_at_matcher(a:s)
  let [_actual, _not, _matcher, _expected] = tokens
  let [actual, not, matcher, expected] = tokens

  if a:mode ==# 'eval'
    if s:is_matcher(_matcher)
      let matcher = string(_matcher)
    endif
    if s:is_custom_matcher(_matcher)
      let expected = '[' . _expected . ']'
    endif
    let not = string(_not)
  endif

  return [actual, not, matcher, expected]
endfunction








" Matchers  "{{{1
" Constants  "{{{2

let s:VALID_MATCHERS_EQUALITY = [
\   '!=',
\   '==',
\   'is',
\   'isnot',
\
\   '!=?',
\   '==?',
\   'is?',
\   'isnot?',
\
\   '!=#',
\   '==#',
\   'is#',
\   'isnot#',
\ ]

let s:VALID_MATCHERS_REGEXP = [
\   '!~',
\   '=~',
\
\   '!~?',
\   '=~?',
\
\   '!~#',
\   '=~#',
\ ]

let s:VALID_MATCHERS_ORDERING = [
\   '<',
\   '<=',
\   '>',
\   '>=',
\
\   '<?',
\   '<=?',
\   '>?',
\   '>=?',
\
\   '<#',
\   '<=#',
\   '>#',
\   '>=#',
\ ]

let s:VALID_MATCHERS = (s:VALID_MATCHERS_EQUALITY
\                       + s:VALID_MATCHERS_ORDERING
\                       + s:VALID_MATCHERS_REGEXP)




function! s:are_matched(value_actual, expr_matcher, value_expected)  "{{{2
  if s:is_custom_matcher(a:expr_matcher)
    let custom_matcher_name = a:expr_matcher
    let matcher = get(s:custom_matchers, custom_matcher_name, 0)
    if matcher is 0
      throw
      \ 'vspec:InvalidOperation:Unknown custom matcher - '
      \ . string(custom_matcher_name)
    endif
    let Match = get(matcher, 'match', 0)
    if Match is 0
      throw
      \ 'vspec:InvalidOperation:Custom matcher does not have match function - '
      \ . string(custom_matcher_name)
    endif
    return !!call(
    \   Match,
    \   [a:value_actual] + a:value_expected,
    \   matcher
    \ )
  elseif s:is_equality_matcher(a:expr_matcher)
    let type_equality = type(a:value_actual) == type(a:value_expected)
    if s:is_negative_matcher(a:expr_matcher) && !type_equality
      return s:TRUE
    else
      return type_equality && eval('a:value_actual ' . a:expr_matcher . ' a:value_expected')
    endif
  elseif s:is_ordering_matcher(a:expr_matcher)
    if (type(a:value_actual) != type(a:value_expected)
    \   || !s:is_orderable_type(a:value_actual)
    \   || !s:is_orderable_type(a:value_expected))
      return s:FALSE
    endif
    return eval('a:value_actual ' . a:expr_matcher . ' a:value_expected')
  elseif s:is_regexp_matcher(a:expr_matcher)
    if type(a:value_actual) != type('') || type(a:value_expected) != type('')
      return s:FALSE
    endif
    return eval('a:value_actual ' . a:expr_matcher . ' a:value_expected')
  else
    throw 'vspec:InvalidOperation:Unknown matcher - ' . string(a:expr_matcher)
  endif
endfunction




function! s:generate_default_failure_message(i)  "{{{2
  return [
  \   '  Actual value: ' . string(a:i.value_actual),
  \   'Expected value: ' . string(a:i.value_expected),
  \ ]
endfunction




function! s:generate_failure_message(i)  "{{{2
  let matcher = get(s:custom_matchers, a:i.value_matcher, 0)
  if matcher is 0
    return s:generate_default_failure_message(a:i)
  else
    let method_name =
    \ a:i.value_not == ''
    \ ? 'failure_message_for_should'
    \ : 'failure_message_for_should_not'
    let Generate = get(
    \   matcher,
    \   method_name,
    \   0
    \ )
    if Generate is 0
      return s:generate_default_failure_message(a:i)
    else
      let values = [a:i.value_actual]
      if a:i.expr_expected != ''
        call extend(values, a:i.value_expected)
      endif
      let maybe_message = call(Generate, values, matcher)
      return
      \ type(maybe_message) == type('')
      \ ? [maybe_message]
      \ : maybe_message
    endif
  endif
endfunction




function! s:is_custom_matcher(expr_matcher)  "{{{2
  return a:expr_matcher =~# '^to'
endfunction




function! s:is_equality_matcher(expr_matcher)  "{{{2
  return 0 <= index(s:VALID_MATCHERS_EQUALITY, a:expr_matcher)
endfunction




function! s:is_matcher(expr_matcher)  "{{{2
  return 0 <= index(s:VALID_MATCHERS, a:expr_matcher) || s:is_custom_matcher(a:expr_matcher)
endfunction




function! s:is_negative_matcher(expr_matcher)  "{{{2
  " FIXME: Ad hoc way.
  return s:is_matcher(a:expr_matcher) && a:expr_matcher =~# '\(!\|not\)'
endfunction




function! s:is_orderable_type(value)  "{{{2
  " FIXME: +float
  return type(a:value) == type(0) || type(a:value) == type('')
endfunction




function! s:is_ordering_matcher(expr_matcher)  "{{{2
  return 0 <= index(s:VALID_MATCHERS_ORDERING, a:expr_matcher)
endfunction




function! s:is_regexp_matcher(expr_matcher)  "{{{2
  return 0 <= index(s:VALID_MATCHERS_REGEXP, a:expr_matcher)
endfunction




function! s:split_at_matcher(s)  "{{{2
  let tokens = matchlist(a:s, s:RE_SPLIT_AT_MATCHER)
  return tokens[1:4]
endfunction

let s:RE_SPLIT_AT_MATCHER =
\ printf(
\   '\C\v^(.{-})\s+%%((not)\s+)?(%%(%%(%s)[#?]?)|to\w+>)\s*(.*)$',
\   join(
\     map(
\       reverse(sort(copy(s:VALID_MATCHERS))),
\       'escape(v:val, "=!<>~#?")'
\     ),
\     '|'
\   )
\ )








" Tools  "{{{1
function! s:cmd_ResetContext()  "{{{2
  call filter(s:get_hinted_scope(), string(s:FALSE))
  call extend(s:get_hinted_scope(), deepcopy(s:saved_scope), 'force')
endfunction




function! s:cmd_SaveContext()  "{{{2
  let s:saved_scope = deepcopy(s:get_hinted_scope())
endfunction




function! s:fail(message)  "{{{2
  throw 'vspec:InvalidOperation:' . a:message
endfunction




function! s:get_hinted_scope()  "{{{2
  return eval(s:expr_hinted_scope)
endfunction




function! s:get_hinted_sid()  "{{{2
  return eval(s:expr_hinted_sid)
endfunction




function! vspec#scope()  "{{{2
  return s:
endfunction




function! vspec#sid()  "{{{2
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID>  <SID>








" __END__  "{{{1
" vim: foldmethod=marker
