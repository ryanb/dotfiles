#!/bin/bash

./t/check-vspec-result <(cat <<'END'
describe ':SKIP'
  it 'should stop the current example as a success'
    SKIP 'This is a test'
    echo 'This line will never be reached.'
  end
end
END
) <(cat <<'END'
ok 1 - # SKIP :SKIP should stop the current example as a success - 'This is a test'
1..1
END
)

# vim: filetype=sh
