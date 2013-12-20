describe 'before'
  let g:counter = 0

  before
    let g:counter += 1
  end

  it 'should call the before block for each example (the first time)'
    Expect g:counter == 1
  end

  it 'should call the before block for each example (the second time)'
    Expect g:counter == 2
  end

  it 'should call the before block for each example (the third time)'
    Expect g:counter == 3
  end
end
