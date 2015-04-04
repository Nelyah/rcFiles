
"Maps Coquille to <F2> (undo), <F3> (Next), <F4> (ToCursor)
au FileType coq call coquille#FNMapping()


function! Resize(dir)
  let this = winnr()
  if '+' == a:dir || '-' == a:dir
    execute "normal \<c-w\>k"
    let up = winnr()
    if up != this
      execute "normal \<c-w\>j"
      let x = 'bottom'
    else
      let x = 'top'
    endif
  elseif '>' == a:dir || '<' == a:dir
    execute "normal \<c-w\>h"
    let left = winnr()
    if left != this
      execute "normal \<c-w\>l"
      let x = 'right'
    else
      let x = 'left'
    endif
  endif
  if ('+' == a:dir && 'bottom' == x) || ('-' == a:dir && 'top' == x)
    return "1\<c-v>\<c-w>+"
  elseif ('-' == a:dir && 'bottom' == x) || ('+' == a:dir && 'top' == x)
    return "1\<c-v>\<c-w>-"
  elseif ('<' == a:dir && 'left' == x) || ('>' == a:dir && 'right' == x)
    return "1\<c-v>\<c-w><"
  elseif ('>' == a:dir && 'left' == x) || ('<' == a:dir && 'right' == x)
    return "1\<c-v>\<c-w>>"
  else
    echo "oops. check your ~/.vimrc"
    return "
  endif
 endfunction

