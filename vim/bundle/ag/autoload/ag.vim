" NOTE: You must, of course, install ag / the_silver_searcher

" Location of the ag utility
if !exists("g:agprg")
  let g:agprg="ag --column"
endif

if !exists("g:ag_apply_qmappings")
  let g:ag_apply_qmappings = !exists("g:ag_qhandler")
endif

if !exists("g:ag_apply_lmappings")
  let g:ag_apply_lmappings = !exists("g:ag_lhandler")
endif

if !exists("g:ag_qhandler")
  let g:ag_qhandler="botright copen"
endif

if !exists("g:ag_lhandler")
  let g:ag_lhandler="botright lopen"
endif

function! ag#Ag(cmd, args)
  " If no pattern is provided, search for the word under the cursor
  if empty(a:args)
    let l:grepargs = expand("<cword>")
  else
    let l:grepargs = a:args . join(a:000, ' ')
  end

  " Format, used to manage column jump
  if a:cmd =~# '-g$'
    let g:agformat="%f"
  else
    let g:agformat="%f:%l:%c:%m"
  end

  let grepprg_bak=&grepprg
  let grepformat_bak=&grepformat
  try
    let &grepprg=g:agprg
    let &grepformat=g:agformat
    silent execute a:cmd . " " . escape(l:grepargs, '|')
  finally
    let &grepprg=grepprg_bak
    let &grepformat=grepformat_bak
  endtry

  if a:cmd =~# '^l'
    exe g:ag_lhandler
    let l:apply_mappings = g:ag_apply_lmappings
  else
    exe g:ag_qhandler
    let l:apply_mappings = g:ag_apply_qmappings
  endif

  " If highlighting is on, highlight the search keyword.
  if exists("g:aghighlight")
    let @/=a:args
    set hlsearch
  end

  redraw!

  if l:apply_mappings
    exec "nnoremap <silent> <buffer> q :ccl<CR>"
    exec "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
    exec "nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>"
    exec "nnoremap <silent> <buffer> o <CR>"
    exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"
    exec "nnoremap <silent> <buffer> h <C-W><CR><C-W>K"
    exec "nnoremap <silent> <buffer> H <C-W><CR><C-W>K<C-W>b"
    exec "nnoremap <silent> <buffer> v <C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t"

    exec "nnoremap <silent> <buffer> gv <C-w><cr><C-w>H<C-w>b<C-w>J80<C-w>-5<C-w>+"
    " Interpretation:
    " ^w<cr>  jump to quickfix under cursor (this is a default quickfix window binding)
    " ^wH  slam the new window to the left wall
    " ^wb  go to the bottom-right window, which is the quickfix window
    " ^wJ  slam it to the floor
    " 80^w-  Decrease this window by (at most) 80 lines.
    " 5^w+  Undecrease the quickfix window by 5, so you can see what you're doing

    " TODO: j  Now you probably want to do something on the next line

    echom "ag.vim keys: q=quit <cr>/t/h/v=enter/tab/split/vsplit go/T/H/gv=preview versions of same"
  endif
endfunction

function! ag#AgFromSearch(cmd, args)
  let search =  getreg('/')
  " translate vim regular expression to perl regular expression.
  let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
  call ag#Ag(a:cmd, '"' .  search .'" '. a:args)
endfunction

function! ag#GetDocLocations()
  let dp = ''
  for p in split(&rtp,',')
    let p = p.'/doc/'
    if isdirectory(p)
      let dp = p.'*.txt '.dp
    endif
  endfor
  return dp
endfunction

function! ag#AgHelp(cmd,args)
  let args = a:args.' '.ag#GetDocLocations()
  call ag#Ag(a:cmd,args)
endfunction
