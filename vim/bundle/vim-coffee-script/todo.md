# To do for full support

- Destructuring assignments like:

      [a, b] = c
      {a, b} = c
       └──┴─ these should be highlighted as identifiers

- Smart, lookback outdenting for cases like:

      a = {
        b: ->
          c
        }
      └─ bracket should be put here

- Fix assignments with brackets in these cases:

      a[b] = c[d]
      a[b -= c] = d

  and still highlight these correctly:

      a[b] = c
      a[b[c]] = d
      a[b[c] -= d] = e
