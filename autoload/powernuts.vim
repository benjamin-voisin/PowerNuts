let s:dot_table = []

" We might want to make a smarter version of this that updates only text after
" the last modification, so that it doesn't have to parse the hole file each
" time. But I need something that work, not something blazingly fast
function! Update_dot_table()
	let s:dot_table = []
	let remove_numbers = (stridx(execute('set number?'),"nonumber") >= 0)
	if (remove_numbers)
		set number
	endif
	let lines = split(execute('g/\./p'), '\n')
	if (remove_numbers)
		set nonumber
	endif
	for line in lines
		let line_number = matchstr(line, '\d\+')
		let line_without_leading_spaces = substitute(line, '^\s*', '', '')
		let line_text = substitute(line_without_leading_spaces, '\v^\s*\zs\d+', '', '')
		let result = substitute(line_text, '^.', '', '')
		let k = 1
		for c in result
			if (c == '.')
				let truc = map(synstack(line_number, i), 'synIDattr(v:val, "name")')
				if (index(truc, 'squirrelComments') < 0)
					let s:dot_table = s:dot_table + [[line_number, i]]
				endif
			endif
			let i = i + 1
		endfor
	endfor
endfunction

function! HandleSquirrelOutput(channel, msg)
  let g:squirrel_output += split(substitute(a:msg, '\e\[[0-9;]\+[mK]', '', 'g'), '\n')
endfunction

function! powernuts#Nuts()
  set splitright | vnew info0 |  new goal0 | winc h
  let cmd = "./squirrel -i"
  let options = {'out_cb': 'HandleSquirrelOutput', 'close_cb': 'HandleSquirrelOutput'}

  let g:squirrel_job = job_start(cmd, options)
  let g:squirrel_channel = job_getchannel(g:squirrel_job)
endfunction

function! powernuts#SendInputToSquirrel(input)
  call ch_sendraw(g:squirrel_channel, a:input . "\n")
endfunction

function! powernuts#PrintSquirrelOutput()
  let output_buffer = winbufnr(bufwinid('info0'))
  call setbufline(output_buffer, 1, g:squirrel_output)

endfunction

function! powernuts#UnNut()
  bdelete info0
  bdelete goal0
endfunction

