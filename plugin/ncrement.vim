if exists('g:loaded_ncremnet')
  finish
endif
let g:loaded_ncrement=1

if !exists(":NcrementNext")
  command! -count=1 NcrementNext call ncrement#nextword(<count>)
endif
if !exists(":NcrementPrev")
  command! -count=1 NcrementPrev call ncrement#prevword(<count>)
endif
if !exists(":NcrementNextOf")
  command! -nargs=1 -count=1 NcrementNextOf call ncrement#nextword_of(<f-args>, <count>)
endif
if !exists(":NcrementPrevOf")
  command! -nargs=1 -count=1 NcrementPrevOf call ncrement#prevword_of(<f-args>, <count>)
endif
if !exists(":NcrementUpdateLists")
  command! NcrementUpdateLists call ncrement#update_word_lists()
endif
if !exists(":NcrementCheckLists")
  command! NcrementCheckLists call ncrement#check_word_lists()
endif
