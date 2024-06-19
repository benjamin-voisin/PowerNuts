" Vim syntax file
" Language: Squirrel Prover
" Maintainer: Benjamin Voisin
" Latest Revision: 21 november 2023

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "squirrel"

if has('comments')
  setlocal commentstring=(*%s*)
  setlocal comments=srn:(*,mb:*,ex:*)
  " NOTE: The 'r' and 'o' flags mistake the '*' bullet as a middle comment and
  " will automatically add an extra one after <Enter>, 'o' or 'O'.
  setlocal formatoptions-=t formatoptions-=r formatoptions-=o formatoptions+=cql
  " let b:undo_ftplugin = add(b:undo_ftplugin, 'setl cms< com< fo<')
endif

" setlocal commentstring=(*%s*)
" setlocal comments=srn:(*,mb:*,ex:*)
" @-@ adds the literal @ to iskeyword for @IBAction and similar
setlocal iskeyword+=?,!,@-@,#
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal completefunc=syntaxcomplete#Complete

