if exists('g:loaded_ncremnet')
  finish
endif
let g:loaded_ncrement=1

command! NextWord call ncrement#nextword()
command! PrevWord call ncrement#prevword()
