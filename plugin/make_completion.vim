function! MakeCompletion(A,L,P) abort
  let l:targets = systemlist('make -qp | awk -F'':'' ''/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'' | grep -v Makefile | sort -u')
  return filter(l:targets, 'v:val =~ "^' . a:A . '"')
endfunction

command! -nargs=* -complete=customlist,MakeCompletion Make !make <args>
