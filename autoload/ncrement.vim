function! ncrement#nextword(count) abort
  call s:rotate_word_func(1,a:count)
endfunction
function! ncrement#prevword(count) abort
  call s:rotate_word_func(-1,a:count)
endfunction

let g:ncrement_d_wordlist_1 = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
let g:ncrement_d_wordlist_2 = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let g:ncrement_d_wordlist_3 = ["[ ]", "[x]"]

function! s:rotate_word_func(way,count) abort
  let a:word_positions = {}
  let a:cursor_col = col('.')-1
  let a:workline = getline('.')[a:cursor_col:]


  if !exists("g:ncrement_autoupdate") || g:ncrement_autoupdate != 0
    call ncrement#update_word_list()
  elseif !exists("g:ncrement_wordlists")
    call ncrement#update_word_list()
  endif

  for a:wordlist in g:ncrement_wordlists
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
  for a:wordlist in g:ncrement_wordlists
    if count(a:wordlist,a:targetword) > 0
      let a:target_position = a:word_positions[a:targetword] + 1

      let a:nextidx = (index(a:wordlist,a:targetword)+a:count) % len(a:wordlist)
      let a:nextword = a:wordlist[a:nextidx]

      let a:previdx = (index(a:wordlist,a:targetword)-a:count) % len(a:wordlist)
      let a:prevword = a:wordlist[a:previdx]
    endif
  endfor

  if a:way == 1
    let a:replacer = a:nextword
  else
    let a:replacer = a:prevword
  endif
  
  call cursor(line('.'), a:target_position)
  execute "normal! v" . expand(len(a:targetword)-1) . "lc" . a:replacer
  execute "normal! " . expand(len(a:replacer)-1) . "h"
endfunction

function! ncrement#update_word_list() abort
  let a:wkletg = execute("let g:")
  let a:letg = split(a:wkletg, "\n")
  let a:wordlists_d = []
  let a:wordlists_u = []
  for a:line in a:letg
    let a:listname = split(a:line, " ")[0]
    if stridx(a:listname, "ncrement_d_wordlist_") == 0
      call execute("let a:tmplist = g:" . a:listname)
      call insert(a:wordlists_d, a:tmplist)
    elseif stridx(a:listname, "ncrement_u_wordlist_") == 0
      call execute("let a:tmplist = g:" . a:listname)
      call insert(a:wordlists_u, a:tmplist)
    endif
  endfor

  if exists("g:ncrement_use_dlist") && g:ncrement_use_dlist == 0
    let a:wordlists_d = []
  endif
  
  let g:ncrement_wordlists = sort(a:wordlists_u) + sort(a:wordlists_d)
endfunction
