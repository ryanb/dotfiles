#!/bin/bash

./t/check-vspec-result <(cat <<'END'
describe 'Suite 1'
  it 'should be executed'
  end
end

describe 'Suite 2'
  it 'should be executed and fail'
    Expect foo == bar
  end
end

describe 'Suite 3'
  it 'should be executed'
  end
end
END
) <(cat <<'END'
ok 1 - Suite 1 should be executed
not ok 2 - Suite 2 should be executed and fail
# function <SNR>1_main..vspec#test..6, line 1
# Vim(call):E121: Undefined variable: foo
ok 3 - Suite 3 should be executed
1..3
END
)

# vim: filetype=sh
