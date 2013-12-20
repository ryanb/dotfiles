call vspec#hint({'scope': 'vspec#scope()', 'sid': 'vspec#sid()'})

describe 'Ref'
  it 'should return the value of a script-local variable'
    Expect Ref('s:expr_hinted_scope') ==# 'vspec#scope()'
    Expect Ref('s:expr_hinted_sid') ==# 'vspec#sid()'
    Expect eval(Ref('s:expr_hinted_sid')) =~# '^<SNR>\d\+_$'
  end
end

describe 'Set'
  it 'should modify the value of a script-local variable'
    let original_value = Ref('s:expr_hinted_sid')
    Expect Ref('s:expr_hinted_sid') ==# 'vspec#sid()'

    let l = []
    call Set('s:expr_hinted_sid', l)
    Expect Ref('s:expr_hinted_sid') is l

    call Set('s:expr_hinted_sid', original_value)
    Expect Ref('s:expr_hinted_sid') ==# 'vspec#sid()'
  end
end

describe 'Call'
  it 'should call a script-local function'
    Expect Call('s:is_matcher', '==') to_be_true
    Expect Call('s:is_matcher', '=?') to_be_false
  end

  it 'should call a non-script-local function'
    Expect Call('function', 'type') ==# function('type')
  end
end
