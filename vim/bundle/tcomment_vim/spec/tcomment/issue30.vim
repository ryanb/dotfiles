" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    32


SpecBegin 'title': 'issue30'
            \, 'options': ['vim', {'&selection': 'inclusive'}, {'&selection': 'exclusive'}]
            \, 'scratch': 'issue30_test.c'

It should block comment a single line with <c-_>b.
Should yield Buffer ':norm 2ggb', 'issue30_test_1.c'

