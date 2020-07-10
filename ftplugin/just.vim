if (exists("b:did_ftplugin"))
  finish
endif

let b:did_ftplugin = 1

setlocal iskeyword=a-z,A-Z,48-57,_,-
setlocal commentstring=#\ %s
setlocal makeprg=just\ -f%
