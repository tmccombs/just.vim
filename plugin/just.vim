" Just.vim: Plugin for justfiles
" Maintainer: Thayne McCombs <astrothayne@gmail.com>
" Date: 2020-06-30
" License: Apache2

if exists("g:just_loaded_install")
    finish
endif

let g:just_loaded_install=1

let s:cpo_save = &cpo
set cpo&vim

command -nargs=* -complete=custom,just#Complete Just call just#Run(<q-args>)
command -nargs=* -complete=custom,just#CompleteHere JustHere call just#RunHere(<q-args>)

let &cpo=s:cpo_save
unlet s:cpo_save
