syntax keyword squirrelKeywords
            \ abstract
            \ name
            \ channel
            \ Proof
            \ Qed
            \ intro
            \ exists
            \ foral
            \ induction
            \ auto
            \ expand 
            \ rewrite
            \ euf
            \ set
            \ include
            \ system

syntax keyword squirrelConstants
            \ ok
            \ ko

syntax keyword squirrelStruct
            \ process
            \ lemma

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
            \ message
            \ index
            \ hash

syntax keyword squirrelAdmit admit Admitted

syntax region squirrelComments start="(\*" end="\*)"

hi def link squirrelFunctions   Identifier
hi def link squirrelKeywords    Keyword
hi def link squirrelAdmit       Error
hi def link squirrelConstants   Constant
hi def link squirrelStruct      Function
hi def link squirrelCond        Conditional
hi def link squirrelType        Type
hi def link squirrelOperator    Operator
hi def link squirrelComments    Comment
