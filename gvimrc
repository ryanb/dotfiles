set guioptions-=T " hide toolbar
set lines=55 columns=100

colorscheme railscasts

set guifont=DejaVu\ Sans\ Mono:h13


" Are we in macvim?
if has("gui_macvim")
  " unbind menu keys
  macmenu &Tools.List\ Errors key=<nop>
  macmenu &File.New\ Tab key=<nop>

  " Command bindings
  map <D-t> :CommandT<CR>
  map <D-h> :wincmd h<CR>
  map <D-j> :wincmd j<CR>
  map <D-k> :wincmd k<CR>
  map <D-l> :wincmd l<CR>
  map <D-w> :q<CR>
endif

