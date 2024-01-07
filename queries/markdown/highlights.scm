;;;;;;;;; Custom configuration.

;; Enable fenced_code_block conceal.

([
  (info_string)
  (fenced_code_block_delimiter)
] @conceal
(#set! conceal ""))

(fenced_code_block) @visual
