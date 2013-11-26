silent filetype indent plugin on
runtime! macros/matchit.vim
runtime! plugin/textobj/*.vim
set visualbell

function! SelectInsideFrom(number, position)
  execute "normal ".a:number."G".a:position
  execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
  return [a:number, line("'<"), line("'>")]
endfunction

function! SelectAroundFrom(number, position)
  execute "normal ".a:number."G".a:position
  execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
  return [a:number, line("'<"), line("'>")]
endfunction

function! SelectedRange()
  return [line("'<"), line("'>")]
endfunction

describe 'rubyblock'

  it 'should set a global variable'
    Expect exists('g:loaded_textobj_rubyblock') ==# 1
  end

end

describe 'default'

  it 'should create named key maps'
    for _ in ['<Plug>(textobj-rubyblock-a)', '<Plug>(textobj-rubyblock-i)']
      execute "Expect maparg(".string(_).", 'c') == ''"
      execute "Expect maparg(".string(_).", 'i') == ''"
      execute "Expect maparg(".string(_).", 'n') == ''"
      execute "Expect maparg(".string(_).", 'o') != ''"
      execute "Expect maparg(".string(_).", 'v') != ''"
    endfor
  end

  it 'should be set up mappings for visual and operator-pending modes only'
    Expect maparg('ar', 'c') ==# ''
    Expect maparg('ar', 'i') ==# ''
    Expect maparg('ar', 'n') ==# ''
    Expect maparg('ar', 'o') ==# '<Plug>(textobj-rubyblock-a)'
    Expect maparg('ar', 'v') ==# '<Plug>(textobj-rubyblock-a)'
    Expect maparg('ir', 'c') ==# ''
    Expect maparg('ir', 'i') ==# ''
    Expect maparg('ir', 'n') ==# ''
    Expect maparg('ir', 'o') ==# '<Plug>(textobj-rubyblock-i)'
    Expect maparg('ir', 'v') ==# '<Plug>(textobj-rubyblock-i)'
  end

end

describe '<Plug>(textobj-rubyblock-i)'

  before
    silent tabnew t/samples/class.rb
  end

  after
    silent tabclose
  end

  it 'selects inside of a class'
    Expect SelectInsideFrom(1, '^') ==# [1, 2, 2]
  end

end

describe '<Plug>(textobj-rubyblock-a)'

  before
    silent tabnew t/samples/class.rb
  end

  after
    silent tabclose
  end

  it 'selects all of a class'
    Expect SelectAroundFrom(1, '^') ==# [1, 1, 3]
  end

end

describe '<Plug>(textobj-rubyblock-i)'

  before
    silent tabnew t/samples/commented-end.rb
  end

  after
    silent tabclose
  end

  it 'ignores "end" keyword inside of a comment'
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    TODO
    Expect SelectInsideFrom(1, '^') ==# [1, 2, 2]
  end

end

describe 'if/else blocks'

  before
    silent tabnew t/samples/if-else.rb
  end

  after
    silent tabclose
  end

  it 'ignores nested if/else block'
    for number in [1,2,8]
      Expect SelectInsideFrom(number, '^') ==# [number, 2, 7]
      Expect SelectInsideFrom(number, '0') ==# [number, 2, 7]
      Expect SelectAroundFrom(number, '0') ==# [number, 1, 8]
    endfor
    for number in [1,2,7,8]
      Expect SelectAroundFrom(number, '^') ==# [number, 1, 8]
    endfor
    " this behaviour (already tested in loop) is unintuitive!
    Expect SelectAroundFrom(7, '^') ==# [7, 1, 8]
  end

  it 'selects nested if/else block'
    for number in [3,4,5,6,7]
      Expect SelectInsideFrom(number, '^') ==# [number, 4, 6]
    endfor
    for number in [3,4,5,6]
      Expect SelectAroundFrom(number, '^') ==# [number, 3, 7]
    endfor
    Expect SelectAroundFrom(7, '0') ==# [7, 3, 7]
  end

end

describe 'nested blocks: (module > class > def > do)'

  before
    silent tabnew t/samples/nested-blocks.rb
  end

  after
    silent tabclose
  end

  it 'selects around the module'
    Expect SelectAroundFrom(1, '^') ==# [1, 1, 9]
    Expect SelectAroundFrom(1, '$') ==# [1, 1, 9]
    Expect SelectAroundFrom(9, '^') ==# [9, 1, 9]
    Expect SelectAroundFrom(9, '$') ==# [9, 1, 9]
    " FIXME: these cases may not be intuitive
    Expect SelectAroundFrom(2, '0') ==# [2, 1, 9]
    Expect SelectAroundFrom(8, '^') ==# [8, 1, 9]
  end

  it 'selects inside the module'
    Expect SelectInsideFrom(1, '^') ==# [1, 2, 8]
    Expect SelectInsideFrom(1, '$') ==# [1, 2, 8]
    Expect SelectInsideFrom(9, '^') ==# [9, 2, 8]
    Expect SelectInsideFrom(9, '$') ==# [9, 2, 8]
    Expect SelectInsideFrom(2, '0') ==# [2, 2, 8]
    " inconsistent?
    Expect SelectInsideFrom(8, '$') ==# [8, 2, 8]
    Expect SelectInsideFrom(8, '^') ==# [8, 3, 7]
  end

  it 'selects around the class'
    Expect SelectAroundFrom(2, '^') ==# [2, 2, 8]
    Expect SelectAroundFrom(3, '0') ==# [3, 2, 8]
    Expect SelectAroundFrom(8, '0') ==# [8, 2, 8]
    " FIXME: it feels as though this should work (but it doesn't):
    " Expect SelectAroundFrom(8, '^') ==# [8, 2, 8]
  end

  it 'selects inside the class'
    Expect SelectInsideFrom(2, '^') ==# [2, 3, 7]
    Expect SelectInsideFrom(3, '0') ==# [3, 3, 7]
    Expect SelectInsideFrom(7, '$') ==# [7, 3, 7]
    " FIXME: it feels as though this should work (but it doesn't):
    " Expect SelectInsideFrom(7, '^') ==# [7, 3, 7]
  end

  it 'selects around the `[].each do` block'
    Expect SelectAroundFrom(4, 'fd') ==# [4, 4, 6]
    Expect SelectAroundFrom(4, '$')  ==# [4, 4, 6]
    Expect SelectAroundFrom(5, '0')  ==# [5, 4, 6]
    Expect SelectAroundFrom(6, '0')  ==# [6, 4, 6]
    " FIXME: it feels as though this should work (but it doesn't):
    " Expect SelectAroundFrom(4, '^') ==# [4, 4, 6]
  end

  it 'selects inside the `[].each do` block'
    Expect SelectInsideFrom(4, 'fd') ==# [4, 5, 5]
    Expect SelectInsideFrom(4, '$')  ==# [4, 5, 5]
    Expect SelectInsideFrom(5, '$')  ==# [5, 5, 5]
    Expect SelectInsideFrom(6, '0')  ==# [6, 5, 5]
    " FIXME: it feels as though this should work (but it doesn't):
    " Expect SelectInsideFrom(4, '^')  ==# [4, 5, 5]
  end

  it 'repeating `ar` expands the selection'
    normal 5G
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    Expect SelectedRange() ==# [5,5]
    execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
    Expect SelectedRange() ==# [4,6]
    execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
    Expect SelectedRange() ==# [3,7]
    execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
    Expect SelectedRange() ==# [2,8]
    execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
    Expect SelectedRange() ==# [1,9]
  end

  it 'repeating `ir` contracts the selection'
    normal gg
    execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
    Expect SelectedRange() ==# [1,9]
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    Expect SelectedRange() ==# [2,8]
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    Expect SelectedRange() ==# [3,7]
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    Expect SelectedRange() ==# [4,6]
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    Expect SelectedRange() ==# [5,5]
  end

end

describe 'rubyblocks with a method call'

  after
    silent tabclose
  end

  it 'handles `end.max` style method invocations'
    silent tabnew t/samples/map-dot-max.rb
    Expect SelectInsideFrom(2, '^') ==# [2, 2, 2]
    Expect SelectAroundFrom(2, '^') ==# [2, 1, 3]
  end

end

describe 'oneline conditionals'

  before
    silent tabnew t/samples/oneline-conditionals.rb
  end

  after
    silent tabclose
  end

  it 'is not confused by trailing if/unless statements'
    TODO
    Expect SelectInsideFrom(2, '^') ==# [2, 2, 5]
    Expect SelectAroundFrom(1, '^') ==# [1, 1, 6]
  end

end
