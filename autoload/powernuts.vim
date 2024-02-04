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

