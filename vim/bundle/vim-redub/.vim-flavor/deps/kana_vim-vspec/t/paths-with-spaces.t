#!/bin/bash

function f
{
  # FIXME: Almost same as t/check-vspec-result
  diff="$(diff --unified "$2" <(./bin/vspec "$PWD" 'foo bar' "$1"))"
  if [ $? = 0 ]
  then
    echo 'ok 1'
  else
    echo 'not ok 1'
    echo "$diff" | sed 's/^/# /'
  fi
  echo '1..1'
}

f <(cat <<'END'
describe './bin/vspec'
  it 'should handle pahts which contain spaces'
    let paths = split(&runtimepath, ',')
    Expect paths[0] ==# getcwd()
    Expect paths[1] ==# 'foo bar'
    Expect paths[-2] ==# 'foo bar/after'
    Expect paths[-1] ==# getcwd() . '/after'
  end
end
END
) <(cat <<'END'
ok 1 - ./bin/vspec should handle pahts which contain spaces
1..1
END
)

# vim: filetype=sh
