if exists('gloaded_fzf_custom')
  finish
endif
let g:gloaded_fzf_custom = 1

let s:cpo_save = &cpo
set cpo&vim

command! -bang -nargs=* FzfNeoRg call
      \ fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --
      \ ".shellescape(<q-args>), 1, fzf#vim#with_preview(
      \ {"options": ["--preview-window", <SID>preview_window()]}
      \ ), <bang>0)

let s:preview_window = "nohidden,+{2}-/2|hidden,down,+{2}-/2"
let s:preview_threshold = "160"

function s:preview_window() abort
  let states = split(s:preview_window, "|")
  if len(states) == 1 || len(states) > 2
    return s:preview_window
  endif
  if winwidth(0) < str2nr(s:preview_threshold)
    return states[1]
  endif
  return states[0]
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
