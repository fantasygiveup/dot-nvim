if exists('gloaded_fzf_goodies')
  finish
endif
let g:gloaded_fzf_goodies = 1

let s:cpo_save = &cpo
set cpo&vim

" FzfNeoRg.
" Same as FzfRg. In addition, computes preview settings based on window width.
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

" FzfNeoFiles.
" Same as FzfFiles. In addition, computes preview settings based on window width.
command! -bang -nargs=? -complete=dir FzfNeoFiles call fzf#vim#files(<q-args>, fzf#vim#with_preview(
      \ { "options" : [ "--preview-window", <SID>preview_window() ] }
      \ ), <bang>0)

" FzfProjects.
" Search for git project via fzf and change fs path.
" Better to use along with something like `vim-projectroot` to set path back on buffer change.
let s:term_yellow_fg='\033[0;33m'
let s:term_reset='\033[0m'
let s:fzf_projects_fd_cmd = "fdfind --hidden --case-sensitive --absolute-path --exec echo -e '"
      \ . s:term_yellow_fg . "{//}" . s:term_reset . "' ';' '^\.git$'"
let s:fzf_projects_root = $HOME
let s:fzf_projects_cd_cmd = "lcd"

command! -nargs=* -bang FzfProjects call fzf#run(
      \ fzf#wrap({ "sink*" : function( "<SID>fzf_projects_handler" ),
      \ "source": join([s:fzf_projects_fd_cmd, " ", s:fzf_projects_root]),
      \ "options": [
        \ "--prompt", "Projects> ",
        \ "--ansi"
        \ ] }, <bang>0)
      \ )

function s:fzf_projects_handler(path) abort
  exec s:fzf_projects_cd_cmd . " " a:path[0]
  call timer_start(100, {-> execute("FzfNeoFiles")})
endfunction

" FzfNeoBuffers.
" Same as FzfBuffers. In addition, computes preview settings based on window width.
command! -bar -bang -nargs=? -complete=buffer FzfNeoBuffers call
      \ fzf#vim#buffers(<q-args>, fzf#vim#with_preview(
      \ { "placeholder": "{1}", "options": [ "--preview-window", <SID>preview_window() ] }), <bang>0)

let &cpo = s:cpo_save
unlet s:cpo_save
