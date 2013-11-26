" tComment.vim -- An easily extensible & universal comment plugin 
" @Author:      Tom Link (micathom AT gmail com)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 2012-11-26.
" @Revision:    778
" GetLatestVimScripts: 1173 1 tcomment.vim

if &cp || exists('loaded_tcomment')
    finish
endif
let loaded_tcomment = 209

if !exists('g:tcommentMaps')
    " If true, set maps.
    let g:tcommentMaps = 1   "{{{2
endif

if !exists("g:tcommentMapLeader1")
    " g:tcommentMapLeader1 should be a shortcut that can be used with 
    " map, imap, vmap.
    let g:tcommentMapLeader1 = '<c-_>' "{{{2
endif

if !exists("g:tcommentMapLeader2")
    " g:tcommentMapLeader2 should be a shortcut that can be used with 
    " map, xmap.
    let g:tcommentMapLeader2 = '<Leader>_' "{{{2
endif

if !exists("g:tcommentMapLeaderOp1")
    " See |tcomment-operator|.
    let g:tcommentMapLeaderOp1 = 'gc' "{{{2
endif

if !exists("g:tcommentMapLeaderOp2")
    " See |tcomment-operator|.
    let g:tcommentMapLeaderOp2 = 'gC' "{{{2
endif

if !exists('g:tcommentTextObjectInlineComment')
    let g:tcommentTextObjectInlineComment = 'ic'   "{{{2
endif


" :display: :[range]TComment[!] ?ARGS...
" If there is a visual selection that begins and ends in the same line, 
" then |:TCommentInline| is used instead.
" The optional range defaults to the current line. With a bang '!', 
" always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TComment
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'G', "<bang>", <f-args>)

" :display: :[range]TCommentAs[!] commenttype ?ARGS...
" TCommentAs requires g:tcomment_{filetype} to be defined.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -complete=customlist,tcomment#Complete -range -nargs=+ TCommentAs 
            \ call tcomment#CommentAs(<line1>, <line2>, "<bang>", <f-args>)

" :display: :[range]TCommentRight[!] ?ARGS...
" Comment the text to the right of the cursor. If a visual selection was 
" made (be it block-wise or not), all lines are commented out at from 
" the current cursor position downwards.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentRight
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'R', "<bang>", <f-args>)

" :display: :[range]TCommentBlock[!] ?ARGS...
" Comment as "block", e.g. use the {&ft}_block comment style. The 
" commented text isn't indented or reformated.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentBlock
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'B', "<bang>", <f-args>)

" :display: :[range]TCommentInline[!] ?ARGS...
" Use the {&ft}_inline comment style.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'I', "<bang>", <f-args>)

" :display: :[range]TCommentMaybeInline[!] ?ARGS...
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentMaybeInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'i', "<bang>", <f-args>)



if g:tcommentMaps
    if g:tcommentMapLeader1 != ''
        exec 'noremap <silent> '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' :TComment<cr>'
        exec 'vnoremap <silent> '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' :TCommentMaybeInline<cr>'
        exec 'inoremap <silent> '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <c-o>:TComment<cr>'
        exec 'noremap <silent> '. g:tcommentMapLeader1 .'p m`vip:TComment<cr>``'
        exec 'inoremap <silent> '. g:tcommentMapLeader1 .'p <c-o>:norm! m`vip<cr>:TComment<cr><c-o>``'
        exec 'noremap '. g:tcommentMapLeader1 .'<space> :TComment '
        exec 'inoremap '. g:tcommentMapLeader1 .'<space> <c-o>:TComment '
        exec 'inoremap <silent> '. g:tcommentMapLeader1 .'r <c-o>:TCommentRight<cr>'
        exec 'noremap <silent> '. g:tcommentMapLeader1 .'r :TCommentRight<cr>'
        exec 'vnoremap <silent> '. g:tcommentMapLeader1 .'i :TCommentInline<cr>'
        exec 'noremap <silent> '. g:tcommentMapLeader1 .'i v:TCommentInline mode=I#<cr>'
        exec 'inoremap <silent> '. g:tcommentMapLeader1 .'i <c-\><c-o>v:TCommentInline mode=#<cr>'
        exec 'noremap '. g:tcommentMapLeader1 .'b :TCommentBlock<cr>'
        exec 'inoremap '. g:tcommentMapLeader1 .'b <c-o>:TCommentBlock<cr>'
        exec 'noremap '. g:tcommentMapLeader1 .'a :TCommentAs '
        exec 'inoremap '. g:tcommentMapLeader1 .'a <c-o>:TCommentAs '
        exec 'noremap '. g:tcommentMapLeader1 .'n :TCommentAs <c-r>=&ft<cr> '
        exec 'inoremap '. g:tcommentMapLeader1 .'n <c-o>:TCommentAs <c-r>=&ft<cr> '
        exec 'noremap '. g:tcommentMapLeader1 .'s :TCommentAs <c-r>=&ft<cr>_'
        exec 'inoremap '. g:tcommentMapLeader1 .'s <c-o>:TCommentAs <c-r>=&ft<cr>_'
        exec 'noremap <silent> '. g:tcommentMapLeader1 .'cc :<c-u>call tcomment#SetOption("count", v:count1)<cr>'
        exec 'noremap '. g:tcommentMapLeader1 .'ca :<c-u>call tcomment#SetOption("as", input("Comment as: ", &filetype, "customlist,tcomment#Complete"))<cr>'
        for s:i in range(1, 9)
            exec 'noremap <silent> '. g:tcommentMapLeader1 . s:i .' :TComment count='. s:i .'<cr>'
            exec 'inoremap <silent> '. g:tcommentMapLeader1 . s:i .' <c-\><c-o>:TComment count='. s:i .'<cr>'
            exec 'vnoremap <silent> '. g:tcommentMapLeader1 . s:i .' :TCommentMaybeInline count='. s:i .'<cr>'
        endfor
        unlet s:i
    endif
    if g:tcommentMapLeader2 != ''
        exec 'noremap <silent> '. g:tcommentMapLeader2 .'_ :TComment<cr>'
        exec 'xnoremap <silent> '. g:tcommentMapLeader2 .'_ :TCommentMaybeInline<cr>'
        exec 'noremap <silent> '. g:tcommentMapLeader2 .'p vip:TComment<cr>'
        exec 'noremap '. g:tcommentMapLeader2 .'<space> :TComment '
        exec 'xnoremap <silent> '. g:tcommentMapLeader2 .'i :TCommentInline<cr>'
        exec 'noremap <silent> '. g:tcommentMapLeader2 .'r :TCommentRight<cr>'
        exec 'noremap '. g:tcommentMapLeader2 .'b :TCommentBlock<cr>'
        exec 'noremap '. g:tcommentMapLeader2 .'a :TCommentAs '
        exec 'noremap '. g:tcommentMapLeader2 .'n :TCommentAs <c-r>=&ft<cr> '
        exec 'noremap '. g:tcommentMapLeader2 .'s :TCommentAs <c-r>=&ft<cr>_'
    endif
    if g:tcommentMapLeaderOp1 != ''
        exec 'nnoremap <silent> '. g:tcommentMapLeaderOp1 .' :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \| set opfunc=tcomment#Operator<cr>g@'
        for s:i in range(1, 9)
            exec 'nnoremap <silent> '. g:tcommentMapLeaderOp1 . s:i .'c :let w:tcommentPos = getpos(".") \| call tcomment#SetOption("count", '. s:i .') \| set opfunc=tcomment#Operator<cr>g@'
        endfor
        unlet s:i
        exec 'nnoremap <silent> '. g:tcommentMapLeaderOp1 .'c :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLine<cr>g@$'
        exec 'nnoremap <silent> '. g:tcommentMapLeaderOp1 .'b :let w:tcommentPos = getpos(".") \| call tcomment#SetOption("mode_extra", "B") \| set opfunc=tcomment#OperatorLine<cr>g@'
        exec 'xnoremap <silent> '. g:tcommentMapLeaderOp1 .' :TCommentMaybeInline<cr>'
    endif
    if g:tcommentMapLeaderOp2 != ''
        exec 'nnoremap <silent> '. g:tcommentMapLeaderOp2 .' :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorAnyway<cr>g@'
        exec 'nnoremap <silent> '. g:tcommentMapLeaderOp2 .'c :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLineAnyway<cr>g@$'
        exec 'nnoremap <silent> '. g:tcommentMapLeaderOp2 .'b :let w:tcommentPos = getpos(".") \| call tcomment#SetOption("mode_extra", "B") \| set opfunc=tcomment#OperatorLine<cr>g@'
        exec 'xnoremap <silent> '. g:tcommentMapLeaderOp2 .' :TCommentMaybeInline!<cr>'
    endif
    if g:tcommentTextObjectInlineComment != ''
        exec 'vnoremap' g:tcommentTextObjectInlineComment ':<c-U>silent call tcomment#TextObjectInlineComment()<cr>'
        exec 'omap' g:tcommentTextObjectInlineComment ':normal v'. g:tcommentTextObjectInlineComment .'<cr>'
    endif
endif

" vi: ft=vim:tw=72:ts=4:fo=w2croql
