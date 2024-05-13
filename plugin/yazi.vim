" Copyright (c) 2015 François Cabrol
" Copyright (c) 2021 Elijah Danko (me@elijahdanko.net)
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


" ================ yazi =======================
let s:choice_file_default_path = '/tmp/vim-yazi-chosenfile'

if exists('g:yazi_choice_file')
  if empty(glob(g:yazi_choice_file))
    let s:choice_file_path = g:yazi_choice_file
  else
    echom "Message from *yazi.vim* :"
    echom "You've set the g:yazi_choice_file variable."
    echom "Please use the path for a file that does not already exist."
    echom "Using " . s:choice_file_default_path . " for now..."
  endif
endif

if !exists('s:choice_file_path')
  let s:choice_file_path = s:choice_file_default_path
endif

if exists('g:yazi_command_override')
  let s:yazi_command = g:yazi_command_override
else
  let s:yazi_command = 'yazi'
endif

function! OpenYaziIn(path, edit_cmd)
  let currentPath = expand(a:path)
  silent exec '!' s:yazi_command . ' --chooser-file ' . s:choice_file_path . ' "' . currentPath . '"'
  if filereadable(s:choice_file_path)
    for f in readfile(s:choice_file_path)
      let simplifiedPath = simplify(f)
      if isdirectory(simplifiedPath)
        call OpenYaziIn(simplifiedPath, a:edit_cmd)
      else
        exec a:edit_cmd . fnamemodify(simplifiedPath, ":~:.")
      endif
    endfor
    call delete(s:choice_file_path)
  endif
  redraw!
  " reset the filetype to fix the issue that happens
  " when opening yazi on VimEnter (with `vim .`)
  filetype detect
endfun

let s:yazi_default_edit_cmd='edit '

command! YaziCurrentFile call OpenYaziIn("%", s:yazi_default_edit_cmd)
command! YaziCurrentDirectory call OpenYaziIn("%:p:h", s:yazi_default_edit_cmd)
command! YaziWorkingDirectory call OpenYaziIn(".", s:yazi_default_edit_cmd)
command! Yazi YaziCurrentFile

function! s:isdir(dir)
  if &l:bufhidden =~# '\vunload|delete|wipe'
    return 0 " In a temporary special buffer (likely from a plugin).
  endif
  return !empty(a:dir) && (isdirectory(a:dir) ||
    \ (!empty($SYSTEMDRIVE) && isdirectory('/' . tolower($SYSTEMDRIVE[0]).a:dir)))
endf

augroup yazi
  autocmd!
  " Remove netrw directory handlers.
  autocmd VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif
  autocmd BufEnter * if <SID>isdir(expand('%:p')) | call OpenYaziIn('%:p', s:yazi_default_edit_cmd) | endif
augroup END
