function! ncrement#nextword() abort
  call s:rotate_word_func(1)
endfunction
function! ncrement#prevword() abort
  call s:rotate_word_func(-1)
endfunction

let g:wordlist_d_1 = ["a)", "b)", "c)", "d)"]
let g:wordlist_d_2 = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
let g:wordlists = [g:wordlist_d_1, g:wordlist_d_2]

function! s:rotate_word_func(way) abort
  " Find targets at under or right side of cursor
  let a:word_positions = {}
  let a:cursor_col = col('.')-1
  let a:workline = getline('.')[a:cursor_col:]
  for a:wordlist in g:wordlists
    for a:word in a:wordlist
      let a:foundidx = stridx(a:workline, a:word)
      if a:foundidx > -1
        let a:word_positions[a:word] = a:foundidx + a:cursor_col
      endif
    endfor
  endfor

  " Get the closest target.
  if empty(a:word_positions)
    echo "no word matches"
    return
  endif
  call filter(a:word_positions, "v:val <= " . min(a:word_positions))

  let a:targetword = keys(a:word_positions)[0]
  for a:wordlist in g:wordlists
    if count(a:wordlist,a:targetword) > 0
      let a:nextidx = index(a:wordlist,a:targetword)+1
      let a:nextidx = a:nextidx>=len(a:wordlist) ? 0 : a:nextidx
      let a:nextword = a:wordlist[a:nextidx]

      let a:previdx = index(a:wordlist,a:targetword)-1
      let a:previdx = a:previdx<0 ? len(a:wordlist)-1 : a:previdx
      let a:prevword = a:wordlist[a:previdx]
    endif
  endfor

  if a:way == 1
    let a:replacer = a:nextword
  else
    let a:replacer = a:prevword
  endif
  
  " Replace the word
  execute "normal! h"
  call search(a:targetword, 'z', expand(line('.')))
  execute "normal! v" . expand(len(a:targetword)-1) . "lc" . a:replacer
  execute "normal! " . expand(len(a:replacer)-1) . "h"
endfunction
