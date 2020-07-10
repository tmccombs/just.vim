" Just.vim: Plugin for justfiles
" Maintainer: Thayne McCombs <astrothayne@gmail.com>
" Date: 2020-07-04
" License: Apache2

function s:runJustLocal(args)
    let dir = expand("%:h")
    return system('cd ' . dir . '; just ' . a:args)
endfunction

function s:extractComplete(targets)
    let start = stridx(a:targets, "\n") + 1 " skip description line
    let suggestions = strpart(a:targets, start)
    return substitute(suggestions, '\s\+', "", "g")
endfunction

function just#Complete(ArgLead, CmdLine, CursorPos)
    return s:extractComplete(system("just --list"))
endfunction

function just#CompleteHere(ArgLead, CmdLine, CursorPos)
    return s:extractComplete(s:runJustLocal("--list"))
endfunction

function just#Run(args)
    cexpr system("just " . a:args)
    copen
endfunction

function just#RunHere(args)
    let dir = expand("%:h")
    cexpr s:runJustLocal(a:args)
    copen
endfunction
