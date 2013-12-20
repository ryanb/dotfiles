describe 'bin/vspec'
  it 'should remove user''s directory from the default &runtimepath'
    let current_runtimepath = &runtimepath
    set runtimepath&
    let default_runtimepath = &runtimepath
    let &runtimepath = current_runtimepath

    let cs = split(current_runtimepath, ',')
    let ds = split(default_runtimepath, ',')
    let n = (len(cs) - (len(ds) - 2)) / 2

    for i in range(len(ds) - 2)
      Expect cs[n + i] ==# ds[1 + i]
    endfor
    Expect stridx(ds[0], $HOME) != -1
    Expect stridx(ds[-1], $HOME) != -1
  end

  it 'should not use relative paths for &runtimepath'
    let p = '\v(^|\,)\.(\/|\\|\,|$)'
    Expect &runtimepath !~# p
  end
end
