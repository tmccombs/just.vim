" Vim indent file
" Language: Justfile
" Maintainer: Thayne McCombs <astrothayne@gmail.com>
" Latest Revision: 2020-06-22

if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal indentexpr=GetJustIndent()
setlocal indentkeys=!^F,o,O,<:>
setlocal nosmartindent

if exists("*GetJustIndent")
  finish
endif

let s:cont_pat = '^\s\+.*\\$'
let s:target_pat = '^\k\+.*:=\@!'

function GetJustIndent()
  let current_line = getline(v:lnum)
  if current_line =~# '^\S'
    " If we already have non-indented text don't indent more
    return 0
  endif
  let prev_lnum = v:lnum - 1
  if prev_lnum == 0
    return 0
  endif
  let prev_line = getline(prev_lnum)

  let prev_prev_lnum = prev_lnum - 1
  let prev_prev_line = prev_prev_lnum != 0 ? getline(prev_prev_lnum) : ""
  if prev_line =~ s:cont_pat
    if prev_prev_line =~ s:cont_pat
      return indent(prev_lnum) " continuing a previous line continuation, use the same indent
    else
      " for now, just increase the indent one level
      " TODO: better indenting if it is in a shell recipe using sh/indent.vim?
      " TODO: indent more if we are continuing the target line to set it
      " appart from the recipe?
      return indent(prev_lnum) + shiftwidth()
    endif
  elseif prev_prev_line =~ s:cont_pat
    " Find the indentation of the first line of the continuation, and return
    " the same indent.
    " This is ok, because just only allows continuation inside of recipes
    let lnum = prev_prev_lnum - 1
    let line = getline(lnum)
    while line =~ s:cont_pat
      let lnum -= 1
      let line = getline(lnum)
    endwhile
    return indent(lnum+1)
  elseif prev_line =~ s:target_pat
    " The colon might be inside of a string, if syntax is enabled, let's check
    " for that
    if has('syntax_items')
      let idx = 0
      while idx >= 0
        let idx = match(prev_line, ":=\@!", idx)
        if synIDattr(synID(prev_lnum, idx+1, 1), "name") !~ "String"
          return shiftwidth()
        endif
      endwhile
    else
      " Assume it is a target line for now, and indent
      return shiftwidth()
    endif
  endif
  return indent(prev_lnum)
endfunction
