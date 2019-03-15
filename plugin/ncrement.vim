if exists('g:loaded_ncremnet')
  finish
endif
let g:loaded_ncrement=1

"command! NextWord call ncrement#nextword()
if !exists(":NextWord")
  command! -count=1 NextWord call ncrement#nextword(<count>)
endif
if !exists(":PrevWord")
  command! -count=1 PrevWord call ncrement#prevword(<count>)
endif
if !exists(":UpdateWordList")
  command! UpdateWordList call ncrement#update_word_list()
endif
