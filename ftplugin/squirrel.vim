" Vim syntax file
" Language: Squirrel Prover
" Maintainer: Benjamin Voisin
" Latest Revision: 21 november 2023

if exists("b:current_syntax")
  finish
endif

setlocal commentstring=(*%s*)
setlocal comments=srn:(*,mb:*,ex:*)
" @-@ adds the literal @ to iskeyword for @IBAction and similar
setlocal iskeyword+=?,!,@-@,#
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal completefunc=syntaxcomplete#Complete

let b:current_syntax = "squirrel"
