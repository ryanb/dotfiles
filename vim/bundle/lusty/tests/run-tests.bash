#!/bin/bash

case "$1" in
  -h|--help)
    echo '[VIM=path/to/vim] ./run-tests.bash [test-dir]'
    exit 0
    ;;
  ?*)
    if [ -d "$1" ]; then
      test_dirs="$1"
    else
      echo "Error: $1 unknown"
      exit 1
    fi
esac

if [ ! "$VIM" ]; then
  export VIM=`which vim`
fi

export VIEW=${VIM%/*}/view

export DISPLAY=

vim_version=$($VIM --version | head -n1)
ruby_version=$($VIM --version | grep -- '-lruby' | \
  sed 's/.*-lruby\([^ ]*\).*/\1/')

echo "Testing against:"
echo "  === $VIM ==="
echo "  $vim_version"
echo "  Ruby: $ruby_version"

failures=

if [ ! "$test_dirs" ]; then
  test_dirs=*/
fi

for dir in $test_dirs; do
  cd $dir
  if ! [ -f precondition.vim ] || \
    $VIM -X -N --noplugin -u precondition.vim >/dev/null 2>&1 ; then
    if ! expect -f expect; then
      echo "fail: $dir"
      failures="$failures $dir"
    fi
  fi
  cd ..
done >/dev/null

if [ "$failures" ]; then
  echo
  echo "Failing tests: $failures" >&2
  exit 1
fi

echo Success

