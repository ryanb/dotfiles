#!/bin/bash

./t/check-vspec-result <(cat <<'END'
let s:to_be_empty = {}
function! s:to_be_empty.match(actual)
  return empty(a:actual)
endfunction
function! s:to_be_empty.failure_message_for_should(actual)
  return 'Actual value is ' . string(a:actual)
endfunction
function! s:to_be_empty.failure_message_for_should_not(actual)
  return 'Actual value is empty'
endfunction
call vspec#customize_matcher('to_be_empty', s:to_be_empty)

let s:to_be_multiple_of = {}
function! s:to_be_multiple_of.match(actual, n)
  return a:actual % a:n == 0
endfunction
function! s:to_be_multiple_of.failure_message_for_should(actual, n)
  return 'Actual value is ' . string(a:actual) . ', not multiple of ' . a:n
endfunction
function! s:to_be_multiple_of.failure_message_for_should_not(actual, n)
  return 'Actual value is ' . string(a:actual) . ', multiple of ' . a:n
endfunction
call vspec#customize_matcher('to_be_multiple_of', s:to_be_multiple_of)

let s:to_be_surrounded = {}
function! s:to_be_surrounded.match(actual, l, r)
  return a:actual[0:0] ==# a:l && a:actual[-1:-1] ==# a:r
endfunction
function! s:to_be_surrounded.failure_message_for_should(actual, l, r)
  return 'Actual value ' . string(a:actual) . ' is not surrounded by ' . a:l . ' and ' . a:r
endfunction
function! s:to_be_surrounded.failure_message_for_should_not(actual, l, r)
  return 'Actual value ' . string(a:actual) . ' is surrounded by ' . a:l . ' and ' . a:r
endfunction
call vspec#customize_matcher('to_be_surrounded', s:to_be_surrounded)

describe 'vspec#customize_matcher'
  it 'supports custom failure message for positive case with 0 argument'
    let xs = [1]
    Expect xs to_be_empty
  end

  it 'supports custom failure message for negative case with 0 argument'
    let xs = []
    Expect xs not to_be_empty
  end

  it 'supports custom failure message for positive case with 1 argument'
    let m = 17
    let n = 4
    Expect m not to_be_multiple_of n
    Expect m to_be_multiple_of n
  end

  it 'supports custom failure message for negative case with 1 argument'
    let m = 16
    let n = 4
    Expect m to_be_multiple_of n
    Expect m not to_be_multiple_of n
  end

  it 'supports custom failure message for positive case with 2 arguments'
    let s = '(foo)'
    let l = '<'
    let r = '>'
    Expect s not to_be_surrounded l, r
    Expect s to_be_surrounded l, r
  end

  it 'supports custom failure message for negative case with 2 arguments'
    let s = '(foo)'
    let l = '('
    let r = ')'
    Expect s to_be_surrounded l, r
    Expect s not to_be_surrounded l, r
  end
end
END
) <(cat <<'END'
not ok 1 - vspec#customize_matcher supports custom failure message for positive case with 0 argument
# Expected xs to_be_empty
#     Actual value is [1]
not ok 2 - vspec#customize_matcher supports custom failure message for negative case with 0 argument
# Expected xs not to_be_empty
#     Actual value is empty
not ok 3 - vspec#customize_matcher supports custom failure message for positive case with 1 argument
# Expected m to_be_multiple_of n
#     Actual value is 17, not multiple of 4
not ok 4 - vspec#customize_matcher supports custom failure message for negative case with 1 argument
# Expected m not to_be_multiple_of n
#     Actual value is 16, multiple of 4
not ok 5 - vspec#customize_matcher supports custom failure message for positive case with 2 arguments
# Expected s to_be_surrounded l, r
#     Actual value '(foo)' is not surrounded by < and >
not ok 6 - vspec#customize_matcher supports custom failure message for negative case with 2 arguments
# Expected s not to_be_surrounded l, r
#     Actual value '(foo)' is surrounded by ( and )
1..6
END
)

# vim: filetype=sh
