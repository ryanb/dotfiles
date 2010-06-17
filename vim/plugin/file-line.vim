
function! s:gotoline()
	let file = bufname("%")
	let names =  matchlist( file, '\(.*\):\(\d\+\)')

	if len(names) != 0 && filereadable(names[1])
		let l:bufn = bufnr("%")
		exec ":e " . names[1]
		exec ":" . names[2]
		exec ":bdelete " . l:bufn
		if foldlevel(names[2]) > 0
			exec ":foldopen!"
		endif
	endif

endfunction

autocmd! BufNewFile *:* nested call s:gotoline()

