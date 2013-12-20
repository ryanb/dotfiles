#!/bin/bash

./t/check-vspec-result <(cat <<'END'
describe 'Suite 1'
  it 'should not be executed'
  end
end

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

describe 'Suite 2'
  it 'should not be executed'
  end
end
END
) <(cat <<'END'
# function A..B..C, line 1
# Vim:E492: Not an editor command:   ThisLineIsNotAValidVimScriptStatement
1..0
END
)

# vim: filetype=sh
