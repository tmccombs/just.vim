" Vim syntax file
" Language:     Justfile
" Maintainer:   Thayne McCombs <astrothayne@gmail.com>
" URL:          https://github.com/tmccombs/just.vim
" Last Change:  20 Jun 2020

if exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn iskeyword a-z,A-Z,48-57,_,-

"Comments
syn match justComment "#\%([^!].*\)\?$" contains=@Spell,justTodo
syn keyword justTodo TODO FIXME XXX contained

syn region justShebang start="#!" end="$"

" Identifiers
syn match justSetting "^set \+shell\s+:=.*$" contains=@justString
syn match justModifier "^\%(alias\|export\)" nextgroup=justIdent skipwhite
syn match justIdent "\k\+\s*:=.*$" contains=@justExpr,@justAssign
syn region justInterp start="{{" end="}}" contains=@justExpr contained

syn cluster justExpr contains=@justStr,justOperator,justCmdInterp,justFunc

syn region justFunc start="\k\+(" end=")" contains=@justExpr contained
syn region justParen start="(" end=")" contains=@justExpr contained

" special characters
syn match justQuiet "^\s*@" contained
syn match justAssign ":=" contained
syn match justOperator "[+,]" contained

" strings
syn match justEscapedChar +\\[nrt"\\]+
syn region justRawString start=+'+ end=+'+
syn region justString start=+"+ skip=+\\"+ end=+"+ contains=justEscapedChar oneline
syn region justCmdInterp start="`" end="`" oneline
syn cluster justStr contains=justString,justRawString

syn match justTarget "^@\?\k\+.*:=\@!.*$" contains=justQuiet,@justExpr,justParameter
syn match justParameter "[*+]\?\k\+\s*="

syn region justStatement start="^\s" skip="\\$" end="$" end="#"me=e-1 contains=justInterp,justComment

" Define the default highlighiting.

hi def link justAssign      Operator
hi def link justCmdInterp   Special
hi def link justComment     Comment
hi def link justEscapedChar SpecialChar
hi def link justFunc        Function
hi def link justIdent       Identifier
hi def link justInterp      justIdent
hi def link justModifier    Keyword
hi def link justNextLine    Special
hi def link justOperator    Operator
hi def link justParameter   Identifier
hi def link justParen       Special
hi def link justQuiet       Special
hi def link justRawString   String
hi def link justSetting     Define
hi def link justShebang     SpecialComment
hi def link justStatement   Number
hi def link justString      String
hi def link justTarget      Function
hi def link justTodo        Todo

let b:current_syntax = "just"

let &cpo = s:cpo_save
unlet s:cpo_save
