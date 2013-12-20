call vspec#hint({'scope': 'vspec#scope()'})

describe 'vspec#customize_matcher'
  before
    let b:custom_matchers = copy(Ref('s:custom_matchers'))
  end

  after
    call Set('s:custom_matchers', b:custom_matchers)
  end

  it 'still supports old style usage'
    let caught = !!0
    try
      Expect [] to_be_empty
      let caught = !!0
    catch /^vspec:InvalidOperation:Unknown custom matcher - 'to_be_empty'$/
      let caught = !0
    endtry
    Expect caught to_be_true

    call vspec#customize_matcher('to_be_empty', function('empty'))

    Expect [] to_be_empty
  end

  it 'supports new style usage'
    let caught = !!0
    try
      Expect [] to_be_empty
      let caught = !!0
    catch /^vspec:InvalidOperation:Unknown custom matcher - 'to_be_empty'$/
      let caught = !0
    endtry
    Expect caught to_be_true

    let to_be_empty = {}
    function! to_be_empty.match(actual)
      return empty(a:actual)
    endfunction
    call vspec#customize_matcher('to_be_empty', to_be_empty)

    Expect [] to_be_empty
  end

  it 'rejects matchers without required members'
    call vspec#customize_matcher('to_be_empty', {})

    let caught = !!0
    try
      Expect [] to_be_empty
      let caught = !!0
    catch /^vspec:InvalidOperation:Custom matcher does not have match function - 'to_be_empty'$/
      let caught = !0
    endtry
    Expect caught to_be_true
  end
end
