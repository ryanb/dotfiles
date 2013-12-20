#!/bin/bash

./t/check-vspec-result <(cat <<'END'
describe 'Suite 1'
  it 'should not be executed'
  end
end

describe 'Suite 2'
  function A()
    call B()
  endfunction
  function B()
    call C()
  endfunction
  function C()
    ThisLineIsNotAValidVimScriptStatement
  endfunction
  call A()
  it 'should not be executed'
  end
end

describe 'Suite 3'
  it 'should not be executed'
  end
end
END
) <(cat <<'END'
# function A..B..C, line 1
# Vim:E492: Not an editor command:     ThisLineIsNotAValidVimScriptStatement
1..0
END
)

# vim: filetype=sh
