syntax keyword squirrelTactics
			\ anyintro
			\ use
			\ namelength
			\ with
			\ assert
			\ trans
			\ sym
			\ have
			\ case
			\ const
			\ adv
			\ collision
			\ depends
			\ eqnames
			\ eqtraces
			\ euf
			\ executable
			\ exists
			\ Exists
			\ splitseq
			\ remember
			\ expand
			\ fresh
			\ forall
			\ Forall
			\ help
			\ id
			\ clear
			\ prof
			\ induction
			\ intro
			\ apply
			\ crypto
			\ generalize
			\ dependent
			\ revert
			\ destruct
			\ as
			\ left
			\ notleft
			\ print
			\ search
			\ project
			\ right
			\ simpl
			\ reduce
			\ simpl_left
			\ split
			\ subst
			\ rewrite
			\ true
			\ cca1
			\ ddh
			\ gdh
			\ cdh
			\ enckp
			\ enrich
			\ equivalent
			\ expandall
			\ fa
			\ show
			\ deduce
			\ fresh
			\ prf
			\ trivialif
			\ xor
			\ intctxt
			\ splitseq
			\ constseq
			\ localize
			\ memseq
			\ byequiv
			\ diffeq
			\ gcca
			\ rename
			\ gprf

syntax keyword squirrelKeywords
            \ abstract
            \ name
            \ channel
            \ system
            \ equiv

syntax keyword squirrelConstants
            \ ok
            \ ko

syntax keyword squirrelStruct
            \ process
            \ lemma
            \ axiom

syntax match squirrelFunctions "\v(\w[a-zA-Z0-9_']*)\ze\(.*\)"


syntax keyword squirrelOperator
            \ diff
            \ new
            \ out
            \ in
            \ ->
            \ *
            \ =>
            \ <=>

syntax keyword squirrelCond
            \ if
            \ then
            \ else

syntax keyword squirrelType
			\ index
			\ message
			\ boolean
			\ bool
			\ timestamp
			\ large
			\ name_fixed_length

syntax keyword squirrelAdmit admit Admitted Abort

syntax region squirrelComments start="(\*" end="\*)"

hi def link squirrelFunctions   Identifier
hi def link squirrelKeywords    Keyword
hi def link squirrelTactics     Keyword
hi def link squirrelAdmit       Error
hi def link squirrelConstants   Constant
hi def link squirrelStruct      Function
hi def link squirrelCond        Conditional
hi def link squirrelType        Type
hi def link squirrelOperator    Operator
hi def link squirrelComments    Comment


if &t_Co > 16
  if &background ==# 'dark'
    hi def PowerNutsChecked ctermbg=17 guibg=#113311
  else
    hi def PowerNutsChecked ctermbg=17 guibg=LightGreen
  endif
else
  hi def PowerNutsChecked ctermbg=4 guibg=LightGreen
endif
hi def link PowerNutsError Error
hi def link PowerNutsOmitted squirrelAdmit
