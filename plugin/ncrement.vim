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
if !exists(":NextWordOf")
  command! -nargs=1 -count=1 NextWordOf call ncrement#nextword_of(<f-args>, <count>)
endif
if !exists(":PrevWordOf")
  command! -nargs=1 -count=1 PrevWordOf call ncrement#prevword_of(<f-args>, <count>)
endif
if !exists(":UpdateWordLists")
  command! UpdateWordLists call ncrement#update_word_lists()
endif
if !exists(":CheckWordLists")
  command! CheckWordLists call ncrement#check_word_lists()
endif
