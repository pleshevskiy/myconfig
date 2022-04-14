aug config_fold
  au!
  au FileType * call <SID>ConfigFold()
aug END

function! s:ConfigFold()
  let l:ft = &g:filetype

  if l:ft ==# 'vim'
    call <SID>SetlFold('marker', 0)
  elseif l:ft ==# 'markdown'
    return
  else
    call <SID>SetlFold('syntax', 99)
  endif
endfunction

function! s:SetlFold(method, lvl)
  let &foldmethod = a:method
  let &foldlevel = a:lvl
endfunction
