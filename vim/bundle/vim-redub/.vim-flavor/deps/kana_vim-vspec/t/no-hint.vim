function! Do(command)
  let c = 0
  try
    let c += 1
    execute a:command
    let c += 1
  catch /^vspec:InvalidOperation:/
    let c += 100
  endtry
  return c
endfunction

describe ':ResetContext'
  it 'should fail without vspec#hint()'
    Expect Do('ResetContext') == 101
  end
end

describe ':SaveContext'
  it 'should fail without vspec#hint()'
    Expect Do('SaveContext') == 101
  end
end

describe 'Call'
  it 'should fail without vspec#hint()'
    Expect Do('echo Call(''s:foo'')') == 101
  end
end

describe 'Ref'
  it 'should fail without vspec#hint()'
    Expect Do('echo Ref(''s:foo'')') == 101
  end
end

describe 'Set'
  it 'should fail without vspec#hint()'
    Expect Do('echo Set(''s:foo'', ''bar'')') == 101
  end
end
