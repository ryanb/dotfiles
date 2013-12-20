" Remove paths for vim-vspec fetched by vim-flavor from &runtimepath to
" * Avoid applying after/indent/vim.vim twice.
" * Apply only after/indent/vim.vim of the current version,
"   not one of the fetched version.
let &runtimepath =
\ join(
\   filter(
\     split(&runtimepath, ','),
\     'v:val !~# ''\.vim-flavor/deps/kana_vim-vspec'''
\   ),
\   ','
\ )

silent filetype plugin indent on
syntax enable

describe 'Automatic indentation'
  function! s:before()
    new
    setfiletype vim
    setlocal expandtab shiftwidth=2
  endfunction

  function! s:after()
    close!
  endfunction

  it 'should indent lines after :describe'
    call s:before()

    execute 'normal!' 'i' . join([
    \   'describe ''foo''',
    \   'bar',
    \   'end',
    \ ], "\<Return>")

    Expect getline(1, '$') ==# [
    \   'describe ''foo''',
    \   '  bar',
    \   'end',
    \ ]

    call s:after()
  end

  it 'should indent lines after :it'
    call s:before()

    execute 'normal!' 'i' . join([
    \   'describe ''foo''',
    \   'it ''bar''',
    \   'baz',
    \   'end',
    \   'end',
    \ ], "\<Return>")

    Expect getline(1, '$') ==# [
    \   'describe ''foo''',
    \   '  it ''bar''',
    \   '    baz',
    \   '  end',
    \   'end',
    \ ]

    call s:after()
  end

  it 'should indent lines after :before'
    call s:before()

    execute 'normal!' 'i' . join([
    \   'describe ''foo''',
    \   'before',
    \   'qux',
    \   'end',
    \   'it ''bar''',
    \   'baz',
    \   'end',
    \   'end',
    \ ], "\<Return>")

    Expect getline(1, '$') ==# [
    \   'describe ''foo''',
    \   '  before',
    \   '    qux',
    \   '  end',
    \   '  it ''bar''',
    \   '    baz',
    \   '  end',
    \   'end',
    \ ]

    call s:after()
  end

  it 'should indent lines after :after'
    call s:before()

    execute 'normal!' 'i' . join([
    \   'describe ''foo''',
    \   'after',
    \   'qux',
    \   'end',
    \   'it ''bar''',
    \   'baz',
    \   'end',
    \   'end',
    \ ], "\<Return>")

    Expect getline(1, '$') ==# [
    \   'describe ''foo''',
    \   '  after',
    \   '    qux',
    \   '  end',
    \   '  it ''bar''',
    \   '    baz',
    \   '  end',
    \   'end',
    \ ]

    call s:after()
  end
end
