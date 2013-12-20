source plugin/redub.vim

function CloseAllBuffers()
  for l:n in range(1, bufnr("$"))
    if bufexists(l:n)
      exec 'bdelete! ' . l:n
    endif
  endfor
endfunction

function CleanOutTmp()
  if !isdirectory("tmp")
    call mkdir("tmp")
  endif

  !rm tmp/*

  " Note: I would have preferred the following code to shelling out on the
  " line above, but for some reason the glob fails to find the files on
  " Travis. I'd love to know why.
  "
  " for l:file_name in glob("./tmp/*", 1, 1)
  "   call delete(l:file_name)
  " end
endfunction

function InsertText(text)
  exec 'normal i' . a:text
endfunction

describe 'Redub'
  before
    call CloseAllBuffers()
    call CleanOutTmp()
  end

  it 'renames the current buffer'
    call InsertText('Hello, world!')
    write tmp/foo.txt

    Redub tmp/bar.txt

    Expect bufname("%") == "tmp/bar.txt"
  end

  it 'renames the file on disk for the current buffer'
    call InsertText('Hello, world!')
    write tmp/foo.txt

    Redub tmp/bar.txt

    Expect filereadable("tmp/foo.txt") to_be_false
    Expect readfile("tmp/bar.txt") == ["Hello, world!"]
  end

  it 'renames the current buffer given just a target filename with no path'
    call InsertText('Hello, world!')
    write tmp/foo.txt

    Redub bar.txt

    Expect bufname("%") == "tmp/bar.txt"
  end

  it 'renames a file on disk with no open buffer'
    call writefile(["Hello, world!"], "tmp/foo.txt")

    Redub tmp/foo.txt tmp/bar.txt

    Expect filereadable("tmp/foo.txt") to_be_false
    Expect readfile("tmp/bar.txt") == ["Hello, world!"]
  end

  it 'renames an open buffer that is not the current buffer'
    call InsertText('Hello, world!')
    write tmp/foo.txt
    enew

    Redub tmp/foo.txt tmp/bar.txt

    Expect buflisted("tmp/foo.txt") to_be_false
    Expect buflisted("tmp/bar.txt") to_be_true
  end

  it 'renames a file on disk with an open buffer that is not the current buffer'
    call InsertText('Hello, world!')
    write tmp/foo.txt
    enew

    Redub tmp/foo.txt tmp/bar.txt

    Expect filereadable("tmp/foo.txt") to_be_false
    Expect readfile("tmp/bar.txt") == ["Hello, world!"]
  end

end

