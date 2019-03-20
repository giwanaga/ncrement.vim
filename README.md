# ncrement.vim
Call it 'en-crement'.
It's a kind of enhancer for your incremental/decremental actions.

ncrement provides incremental/decremental word-shifting features.  
It behaves similarly to `<C-a>` and `<C-d>` on your editing line.  
Suppose execute `:NcrementNext` (a provided command of ncrement) to change "Monday" to "Tuesday".  

Inspired by [monday.vim](https://www.vim.org/scripts/script.php?script_id=1046) by Stefan Karisson.

## Example
Here show you an example.  
Suppose you have a list as below.

```.vimrc
let g:wordlist_d_1 = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
```
 
And you're editing a line below. Your cursor is at its head ("^" shows).
```example.txt
I'll come to the office next Monday.
^
```

Execute `:NcrementNext` to replace "Monday" to "Tuesday".  
Now your cursor moved to the word found.

```example.txt
I'll come to the office next Tuesday.
                             ^
```

If you think twice and change the day to Monday again, you can execute `:NcrementPrev` to turn it back, instead of undo.

And ncrement *rotates* lists.
Monday is next to Sunday though they are at first and last positions of the list above.


## Usage
### Basic Usage
`:NcrementNext` changes a word to next word in pre-defined list.  
`:NcrementPrev` is for reverse direction.

One `.vimrc` example here.

```.vimrc
nnoremap <silent><leader>n :NcrementNext<CR>
nnoremap <silent><leader>p :NcrementPrev<CR>
```


ncrement can get a parameter "count" as its offset.  
`:2NcrementNext` changes "Monday" to "Wednesday" at once.  
Perhaps more useful keymaps than the shown above are the following.  
With them, `2<leader>n` behaves as same as above `:2NcrementNext`.

```.vimrc
nnoremap <silent><leader>n :<C-u>call ncrement#nextword(v:count1)<CR>
nnoremap <silent><leader>p :<C-u>call ncrement#prevword(v:count1)<CR>
```


Execute `:NcrementCheckLists` to find current active word lists.

### Advanced Usage
You can specify a word list to be searched by ncrement.

```.vimrc
let g:ncrement_u_wordlist_pod = ["morning", "afternoon", "evening"]
nnoremap <silent><leader>sn :NcrementNextOf ncrement_u_wordlist_pod<CR>
nnoremap <silent><leader>sp :NcrementPrevOf ncrement_u_wordlist_pod<CR>
```

Let's suppose that you have a line editing as "TARGET LINE" below.  
Your cursor is at its head.  
When you execute ":NcrementNext", you find "Monday" becomes "Tuesday",  
because "Monday" is the nearest target to your cursor.  
`:NcrementNextOf ncrement_u_wordlist_pod` searches only words in the specified word list.  
I.e. "afternoon" hits first and gets replaced to "evening".  
"Monday" is out of its targets.

```example.txt
<TARGET LINE>
Monday afternoon

:NcrementNext
Tuesday afternoon

:NcrementNextOf ncrement_u_wordlist_pod
Monday evening
```

### Settings
You can define your own word lists in your .vimrc.  
Names of every lists must start with `g:ncrement_u_wordlist_`.

```
let g:ncrement_u_wordlist_1 = ["Female", "Male"]
let g:ncrement_u_wordlist_2 = ["Monkey", "Ape", "Human"]
```

ncrement always fetches word lists to find words.
So your update on the settings above will be reflected immediately.
But it perhaps makes processes slow.
To avoid it, you can have it perform only when you call.

```
let g:ncrement_autoupdate = 0
```

`:NcrementUpdateLists` is the command to update word lists manually.


## Installation
If you're using dein.vim, add ncrement to your dein.toml.

```dein.toml
[[plugins]]
repo = 'giwanaga/ncrement.vim'
```
Then do `:call dein#install()` or reboot your vim.  
Maybe mostly any plugin managers work fine.

