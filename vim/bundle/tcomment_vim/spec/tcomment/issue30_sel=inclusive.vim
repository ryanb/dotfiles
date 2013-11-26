" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    10

SpecBegin 'title': 'issue30 - bug 2 inclusive'
            \, 'options': [{'&selection': 'inclusive'}]
            \, 'scratch': 'issue30_test.c'

It should comment last character with gc.
Should yield Buffer ':norm 3gg$vgc', 'issue30_test_2.c'

