#!/bin/bash

./t/check-vspec-result <(cat <<'END'
describe ':TODO'
  it 'should stop the current example as a failure'
    TODO
  end
end
END
) <(cat <<'END'
not ok 1 - # TODO :TODO should stop the current example as a failure
1..1
END
)

# vim: filetype=sh
