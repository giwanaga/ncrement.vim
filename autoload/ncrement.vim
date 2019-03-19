function! ncrement#nextword(count) abort
  call <SID>rotate_word(1,a:count)
endfunction
function! ncrement#prevword(count) abort
  call <SID>rotate_word(-1,a:count)
endfunction
function! ncrement#nextword_of(listname, count) abort
  call <SID>rotate_word_of(a:listname,1,a:count)
endfunction
function! ncrement#prevword_of(listname, count) abort
  call <SID>rotate_word_of(a:listname,-1,a:count)
endfunction

let g:ncrement_d_wordlist_1 = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
let g:ncrement_d_wordlist_2 = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let g:ncrement_d_wordlist_3 = ["[ ]", "[x]"]

function! s:fetch_wordlists_specified(listname) abort
  call execute("let a:tmplist = g:" . a:listname)
  return [a:tmplist]
endfunction

function! s:fetch_wordlists() abort
  if !exists("g:ncrement_autoupdate") || g:ncrement_autoupdate != 0
    call ncrement#update_word_lists()
  elseif !exists("g:ncrement_wordlists")
    call ncrement#update_word_lists()
  endif
  return g:ncrement_wordlists
endfunction

function! s:rotate_word_of(listname,way,count) abort
  let a:wordlists = <SID>fetch_wordlists_specified(a:listname)
  call <SID>rotate_word_func(a:wordlists,a:way,a:count)
endfunction

function! s:rotate_word(way,count) abort
  let a:wordlists = <SID>fetch_wordlists()
  call <SID>rotate_word_func(a:wordlists,a:way,a:count)
endfunction

function! s:rotate_word_func(wordlists,way,count) abort
  let a:word_positions = {}
  let a:cursor_col = col('.')-1
  let a:workline = getline('.')[a:cursor_col:]

  for a:wordlist in a:wordlists
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

function! ncrement#update_word_lists() abort
  let a:listnames = <SID>fetch_wordlist_names()
  let a:wordlists_d = []
  let a:wordlists_u = []
  for a:listname in a:listnames
    if stridx(a:listname, "ncrement_d_wordlist_") == 0
      call execute("let a:tmplist = g:" . a:listname)
      call insert(a:wordlists_d, a:tmplist)
    elseif stridx(a:listname, "ncrement_u_wordlist_") == 0
      call execute("let a:tmplist = g:" . a:listname)
      call insert(a:wordlists_u, a:tmplist)
    endif
  endfor
  
  let g:ncrement_wordlists = a:wordlists_u + a:wordlists_d
endfunction

function! s:fetch_wordlist_names() abort
  let a:wkletg = execute("let g:")
  let a:letg = split(a:wkletg, "\n")
  let a:listnames_d = []
  let a:listnames_u = []
  for a:line in a:letg
    let a:listname = split(a:line, " ")[0]
    if stridx(a:listname, "ncrement_d_wordlist_") == 0
      call insert(a:listnames_d, a:listname)
    elseif stridx(a:listname, "ncrement_u_wordlist_") == 0
      call insert(a:listnames_u, a:listname)
    endif
  endfor

  if exists("g:ncrement_use_dlists") && g:ncrement_use_dlists == 0
    let a:listnames_d = []
  endif

  return sort(a:listnames_u) + sort(a:listnames_d)
endfunction

function! ncrement#check_word_lists() abort
  if !exists("g:ncrement_autoupdate") || g:ncrement_autoupdate != 0
    call ncrement#update_word_lists()
  elseif !exists("g:ncrement_wordlists")
    call ncrement#update_word_lists()
  endif
  let a:wordlist_names = <SID>fetch_wordlist_names()
  for a:wordlist_name in a:wordlist_names
    echo expand(execute("let g:" . a:wordlist_name))
  endfor
endfunction
