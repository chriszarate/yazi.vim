" DWTFYW License
" Version -1
"
" Do Whatever The Fudge You Want

let s:command = 'yazi'
if exists('g:yazi_command')
  let s:command = g:yazi_command
endif

let s:exec_on_open = 'edit'
if exists('g:yazi_exec_on_open')
  let s:exec_on_open = g:yazi_exec_on_open
endif

function! OpenYaziIn(path)
  const l:chosen_file_path = tempname()

  let l:current_path = expand(a:path)
  if l:current_path == ''
    let l:current_path = expand('.')
  endif

  silent exec '!' s:command . ' --chooser-file ' . l:chosen_file_path . ' "' . l:current_path . '"'

  if filereadable(l:chosen_file_path)
    let l:chosen_dir = v:null
    for l:chosen_path in readfile(l:chosen_file_path)
      const l:simplified_path = simplify(l:chosen_path)
      if isdirectory(l:simplified_path)
        let l:chosen_dir = l:simplified_path " last one wins
      else
        exec s:exec_on_open . ' ' . fnamemodify(l:simplified_path, ":~:.")
      endif
    endfor

    " If a directory was chosen, open it in the current window
    if l:chosen_dir != v:null
      call OpenYaziIn(l:chosen_dir)
    endif

    call delete(l:chosen_file_path)
  endif
  redraw!
  " reset the filetype to fix the issue that happens
  " when opening yazi on VimEnter (with `vim .`)
  filetype detect
endfun

command! YaziCurrentFile call OpenYaziIn("%")
command! YaziCurrentDirectory call OpenYaziIn("%:p:h")
command! YaziWorkingDirectory call OpenYaziIn(".")
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
  autocmd BufEnter * if <SID>isdir(expand('%:p')) | call OpenYaziIn('%:p') | endif
augroup END
