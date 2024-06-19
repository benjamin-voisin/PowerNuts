let s:dot_table = []
let s:checked_groups = [[]]
let s:squirrel_index = 0
let s:answered = 0
let s:answer_type = "info"

fu! StartsWith(longer, shorter) abort
  return a:longer[0:len(a:shorter)-1] ==# a:shorter
endfunction

" We might want to make a smarter version of this that updates only text after
" the last modification, so that it doesn't have to parse the hole file each
" time. But I need something that work, not something blazingly fast
function! Update_dot_table()
	let s:dot_table = [[0,0]]
	let remove_numbers = (stridx(execute('set number?'),"nonumber") >= 0)
	if (remove_numbers)
		set number
	endif
	let old_pos = getpos('.')
	let lines = split(execute('g/\./p'), '\n')
	call setpos('.', old_pos)
	if (remove_numbers)
		set nonumber
	endif
	for line in lines
		let line_number = matchstr(line, '\d\+')
		let line_without_leading_spaces = substitute(line, '^\s*', '', '')
		let line_text = substitute(line_without_leading_spaces, '\v^\s*\zs\d+', '', '')
		let result = substitute(line_text, '^.', '', '')
		let i = 1
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

function! GetTextBetweenPositions(startLine, startCol, stopLine, stopCol)
    " Get lines between start and stop lines
    let lines = getline(a:startLine, a:stopLine)
	let s:checked_groups += [[]]

    " If start and stop lines are the same, get the substring between columns
    if a:startLine == a:stopLine
        let lineText = lines[0][a:startCol-1 : a:stopCol-1]
		let m = matchaddpos('PowerNutsChecked',[a:startLine, a:startCol, a:stopCol - a:startCol])
		let s:checked_groups[-1] += [m]
    else
        " Remove text before the starting column in the first line
        let lines[0] = lines[0][a:startCol-1:]
		" Highlight the first line
		let line_width = strdisplaywidth(getline(a:startLine))
		let m = matchaddpos('PowerNutsChecked',[[a:startLine, a:startCol, line_width - a:startCol]])
		let s:checked_groups[-1] += [m]

        " Remove text after the stopping column in the last line
        let lines[-1] = lines[-1][:a:stopCol-1]
		" Highilght the last line
		let m = matchaddpos('PowerNutsChecked',[[a:stopLine, 0, a:stopCol]])
		let s:checked_groups[-1] += [m]
        let lineText = join(lines, "\n")
		" Highlight lines in between
		let i = a:startLine + 1
		while i < a:stopLine
			let m = matchaddpos('PowerNutsChecked',[i])
			let s:checked_groups[-1] += [m]
			let i = i + 1
		endwhile
    endif

    return lineText
endfunction

function! HandleSquirrelOutput(channel, msg)
	let g:squirrel_output += split(substitute(a:msg, '\e\[[0-9;]\+[mK]', '', 'g'), '\n')
	let s:answered = 1
endfunction

function! powernuts#Nuts()
	set splitright | vnew info0 |  new goal0 | winc h
	let cmd = "squirrel -i"
	let options = {'out_cb': 'HandleSquirrelOutput', 'close_cb': 'HandleSquirrelOutput'}

	if has('nvim')
		echom "Not yet implemented for nvim"
	else
		let g:squirrel_job = job_start(cmd, options)
		let g:squirrel_channel = job_getchannel(g:squirrel_job)
	endif
	sleep 100m
	call powernuts#PrintSquirrelOutput()
endfunction

function! powernuts#SendInputToSquirrel(input)
	call ch_sendraw(g:squirrel_channel, a:input . "\n")
endfunction

function! powernuts#ClearSquirrelGoal()
	let output_buffer = winbufnr(bufwinid('goal0'))
	call deletebufline(output_buffer, 1, '$')
endfunction

function! powernuts#ClearSquirrelInfo()
	let output_buffer = winbufnr(bufwinid('info0'))
	call deletebufline(output_buffer, 1, '$')
endfunction

function! powernuts#PrintSquirrelOutput()
	let goal_buffer = winbufnr(bufwinid('goal0'))
	let info_buffer = winbufnr(bufwinid('info0'))
	let goal_line = 1
	let info_line = 1
	for line in g:squirrel_output 
		if ((StartsWith(line, "[>  [goal>")) || (StartsWith(line, "[>  Goal")))
			let s:answer_type = "goal"
			call powernuts#ClearSquirrelGoal()
		elseif (stridx(line, "[>  [error>") >= 0)
			let s:answer_type = "error"
			call powernuts#ClearSquirrelInfo()
			call RemoveLastColor()
		elseif (stridx(line, "[>") >= 0)
			let s:answer_type = "info"
			call powernuts#ClearSquirrelInfo()
		endif
		if s:answer_type == "goal"
			call setbufline(goal_buffer, goal_line, line)
			let goal_line += 1
		elseif s:answer_type == "info"
			call setbufline(info_buffer, info_line, line)
			let info_line += 1
		elseif s:answer_type == "error"
			call setbufline(info_buffer, info_line, line)
			let info_line += 1
		endif
	endfor
	let g:squirrel_output = []
endfunction

function! powernuts#UnNut()
	bdelete info0
	bdelete goal0
endfunction

function! RemoveLastColor()
	let s:squirrel_index = s:squirrel_index - 1
	" remove highlighting of undone text
	for id in s:checked_groups[-1]
		call matchdelete(id)
	endfor
	let s:checked_groups = s:checked_groups[0:-2]
endfunction

function! powernuts#Previous()
	if (s:squirrel_index > 0)
		call Update_dot_table()
		call powernuts#SendInputToSquirrel('undo 1.')
		call RemoveLastColor()
	endif
endfunction

function! powernuts#GoTo()
	call Update_dot_table()
	" find the first entry in s:dot_table that is before the goto
	let old_pos = getpos('.')
	let old_pos = [old_pos[1], old_pos[2]]
	let best_fit = [0,0]
	" k is the new value for s:squirrel_index
	let k = 0
	for position in s:dot_table
		if (position[0] < old_pos[0])
			let best_fit = position
		elseif (position[0] == old_pos[0] && position[1] <= old_pos[1])
			let best_fit = position
		else
			break
		endif
		let k += 1
	endfor
	if (best_fit[1] > old_pos[1] || (best_fit[1] == old_pos[1] && best_fit[0] > old_pos[0]))
		" If we need to go after where we are
		" We need to iterate over each "dot" like doing many SquirrelNext
		while (s:squirrel_index < k - 1) 
			call powernuts#NextDotWithoutComment()
		endwhile
		call powernuts#PrintSquirrelOutput()
	else
		echom "nrsatienldpaéc"
		" Else, we need to go back
	endif
	"
	" undo the correct number
endfunction

function! powernuts#NextDotWithoutComment()
	call Update_dot_table()
	let text = GetTextBetweenPositions( s:dot_table[s:squirrel_index][0], s:dot_table[s:squirrel_index][1] + 1, s:dot_table[s:squirrel_index + 1][0], s:dot_table[s:squirrel_index + 1][1])
	let s:squirrel_index = s:squirrel_index + 1
	let s:answered = 0
	call powernuts#SendInputToSquirrel(text)
	" Never stops when we send an abstract ? : ?. input... need to be fixed
	" Also for "set"
	" if (StartsWith(text, "set") || StartsWith(text, "abstract"))
	if ((stridx(text, "set") >= 0) || (stridx(text, "abstract") >= 0) || (stridx(text, "channel") >= 0) || (stridx(text, "senc") >= 0) || (stridx(text, "aenc") >= 0) || (stridx(text, "mutable") >= 0))
		sleep 100m
		call powernuts#PrintSquirrelOutput()
	else
		while s:answered == 0
			sleep 100m
		endwhile
		call powernuts#PrintSquirrelOutput()
	endif

endfunction
