;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up the global keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key [f1 ] 'indent-region           ) ;; search-forward-regexp
(global-set-key [f2 ] 'undo                    )
(global-set-key [f3 ] 'call-last-kbd-macro     )
(global-set-key [f4 ] 'start-kbd-macro         )
(global-set-key [f5 ] 'end-kbd-macro           )
(global-set-key [f6 ] 'clear-rectangle         )
(global-set-key [f7 ] 'delete-extract-rectangle)
(global-set-key [f8 ] 'kill-rectangle          )
(global-set-key [f9 ] 'string-rectangle        )
(global-set-key [f10] 'query-replace-regexp    )
(global-set-key [f11] 'yank-rectangle          )
(global-set-key [f12] 'goto-line               )

(global-set-key [insert] 'yank)

(global-set-key [remove] 'kill-region)
(global-set-key [select] 'set-mark-command)

(global-set-key [kp-f1] 'beginning-of-buffer)
(global-set-key [kp-f2] 'end-of-buffer)
(global-set-key [kp-f3] 'delete-other-windows)
(global-set-key [kp-f4] 'kill-line)

;; 
;;visit-tags-table
;; tags-query-replace

(global-set-key [kp-0] 'overwrite-mode)
(global-set-key [kp-1] 'end-of-line)
;;;(global-set-key [kp-2] 'scroll-up)
(global-set-key [kp-2] 'backward-line)
(global-set-key [kp-3] 'end-of-buffer)
(global-set-key [kp-4] 'backward-word)
(global-set-key [kp-5] 'save-buffer)
(global-set-key [kp-6] 'forward-word)
(global-set-key [kp-7] 'beginning-of-line)
;;;(global-set-key [kp-8] 'scroll-down)
(global-set-key [kp-8] 'forward-line)
(global-set-key [kp-9] 'beginning-of-buffer)
(global-set-key [kp-subtract] 'kill-word)
(global-set-key [kp-separator] 'delete-char)
(global-set-key [kp-enter] 'save-buffer)
(global-set-key [kp-decimal] 'copy-region-as-kill)
(global-set-key [kp-period] 'copy-region-as-kill)

(global-set-key [?\C-h] 'delete-backward-char)
(global-set-key [?\C-x ?h] 'help-command)
(global-set-key [?\C-f] 'forward-word)
(global-set-key [?\C-b] 'backward-word)
