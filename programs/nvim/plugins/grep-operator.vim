nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

nnoremap <leader>cj :cnext<cr>
nnoremap <leader>ck :cprev<cr>

function! s:GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    exe "normal! `<v`>y"
  elseif a:type ==# 'char'
    exe "normal! `[v`]y"
  else
    return
  endif

  silent exe ":grep! -R " . shellescape(@@) . " ."
  copen

  let @@ = saved_unnamed_register
endfunction

