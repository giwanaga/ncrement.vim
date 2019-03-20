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
  if !exists("g:ncrement_autoupdate") || g:ncrement_autoupdate != 0
    call ncrement#update_word_lists()
  elseif !exists("g:ncrement_wordlists")
    call ncrement#update_word_lists()
  endif
  call execute("let l:tmplist = g:" . l:listname)
  return [l:tmplist]
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
  let l:wordlists = <SID>fetch_wordlists_specified(a:listname)
  call <SID>rotate_word_func(a:wordlists,a:way,a:count)
endfunction

function! s:rotate_word(way,count) abort
  let l:wordlists = <SID>fetch_wordlists()
  call <SID>rotate_word_func(l:wordlists,a:way,a:count)
endfunction

function! s:rotate_word_func(wordlists,way,count) abort
  let l:word_positions = {}
  let l:cursor_col = col('.')-1
  let l:workline = getline('.')[l:cursor_col:]

  for l:wordlist in a:wordlists
    for l:word in l:wordlist
      let l:foundidx = stridx(l:workline, l:word)
      if l:foundidx > -1
        let l:word_positions[l:word] = l:foundidx + l:cursor_col
      endif
    endfor
  endfor

  " Get the closest target.
  if empty(l:word_positions)
    echo "no word matches"
    return
  endif
  call filter(l:word_positions, "v:val <= " . min(l:word_positions))
  let l:targetword = keys(l:word_positions)[0]
  for l:wordlist in g:ncrement_wordlists
    if count(l:wordlist,l:targetword) > 0
      let l:target_position = l:word_positions[l:targetword] + 1

      let l:nextidx = (index(l:wordlist,l:targetword)+a:count) % len(l:wordlist)
      let l:nextword = l:wordlist[l:nextidx]

      let l:previdx = (index(l:wordlist,l:targetword)-a:count) % len(l:wordlist)
      let l:prevword = l:wordlist[l:previdx]
    endif
  endfor

  if a:way == 1
    let l:replacer = l:nextword
  else
    let l:replacer = l:prevword
  endif

  call cursor(line('.'), l:target_position)
  let l:offset_forward = strlen(substitute(l:targetword, ".", "x", "g")) - 1
  let l:offset_backward = strlen(substitute(l:replacer, ".", "x", "g")) - 1
  execute "normal! v" . l:offset_forward . "lc" . l:replacer
  execute "normal! " . l:offset_backward . "h"
endfunction

function! ncrement#update_word_lists() abort
  let l:listnames = <SID>fetch_wordlist_names()
  let l:wordlists_d = []
  let l:wordlists_u = []
  for l:listname in l:listnames
    if stridx(l:listname, "ncrement_d_wordlist_") == 0
      call execute("let l:tmplist = g:" . l:listname)
      call add(l:wordlists_d, l:tmplist)
    elseif stridx(l:listname, "ncrement_u_wordlist_") == 0
      call execute("let l:tmplist = g:" . l:listname)
      call add(l:wordlists_u, l:tmplist)
    endif
  endfor
  
  let g:ncrement_wordlists = l:wordlists_u + l:wordlists_d
endfunction

function! s:fetch_wordlist_names() abort
  let l:wkletg = execute("let g:")
  let l:letg = split(l:wkletg, "\n")
  let l:listnames_d = []
  let l:listnames_u = []
  for l:line in l:letg
    let l:listname = split(l:line, " ")[0]
    if stridx(l:listname, "ncrement_d_wordlist_") == 0
      call add(l:listnames_d, l:listname)
    elseif stridx(l:listname, "ncrement_u_wordlist_") == 0
      call add(l:listnames_u, l:listname)
    endif
  endfor

  if exists("g:ncrement_use_dlists") && g:ncrement_use_dlists == 0
    let l:listnames_d = []
  endif

  return sort(l:listnames_u) + sort(l:listnames_d)
endfunction

function! ncrement#check_word_lists() abort
  if !exists("g:ncrement_autoupdate") || g:ncrement_autoupdate != 0
    call ncrement#update_word_lists()
  elseif !exists("g:ncrement_wordlists")
    call ncrement#update_word_lists()
  endif
  let l:wordlist_names = <SID>fetch_wordlist_names()
  let l:checkwordlists_result = ["[CheckWordLists Result]\n"]
  for l:wordlist_name in l:wordlist_names
    let l:tmpresult = expand(execute("let g:" . l:wordlist_name))
    call add(l:checkwordlists_result, l:tmpresult)
  endfor

  let l:bufname = "checkwordlists"
  let l:windowsize = len(l:checkwordlists_result)+2
  let l:windowsize = l:windowsize > 10 ? 10 : l:windowsize
  if !bufexists(l:bufname)
    execute l:windowsize . 'split'
    edit `=l:bufname`
    nnoremap <buffer> q <C-w>c
    setlocal bufhidden=hide buftype=nofile noswapfile nobuflisted
    setlocal fileformat=unix
  elseif bufwinnr(l:bufname) != -1
    execute bufwinnr(l:bufname) 'wincmd w'
  else
    execute l:windowsize . 'split'
    edit `=l:bufname`
  endif

  execute ':%d_'
  execute ':normal! i' . join(l:checkwordlists_result)
  execute ':normal! gg'
endfunction
