
;;; package --- Summary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Common Lisp Handbook
;; http://cl-cookbook.sourceforge.net/.emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; no startup msg  
(setq inhibit-startup-message t) ;; Disable startup message 
(toggle-scroll-bar -1)           ;; disable the scrollbar
(tool-bar-mode -1)               ;; To disable the toolbar

;; (menu-bar-mode -1) ;; disable the menu bar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc/Defaults
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq lpr-switches (quote ("-dnosuchprinter")))

(setq default-major-mode (quote text-mode))

(setq text-mode-hook (quote (lambda nil (auto-fill-mode 1))))

(setq fill-column 72)

(setenv "PYTHONIOENCODING" "utf8")

;; how to replace a word in multiple files
;; dired-do-query-replace-regexp
;;   Command: Do `query-replace-regexp' of FROM with TO, on all marked files.

;;tags-query-replace
;;  Command: `Query-replace-regexp' FROM with TO through all files listed in tags table.

(message "INFO: .emacs: setup: Misc/Defaults")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://wikemacs.org/index.php/Package.el
;;
;; The magic starts with the command M-x package-list-packages. 
;;
;; http://stackoverflow.com/questions/14836958/updating-packages-in-emacs
;;
;; http://blog.jorgenschaefer.de/2014/06/the-sorry-state-of-emacs-lisp-package.html
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; first require all of the packages that package requires
;; http://ergoemacs.org/emacs/emacs_package_system.html
;; http://batsov.com/articles/2012/02/19/package-management-in-emacs-the-good-the-bad-and-the-ugly/
;; http://stackoverflow.com/questions/14836958/updating-packages-in-emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
(defvar my-packages
  '(virtualenv ;; needed by python deps so put it first
    virtualenvwrapper
    exec-path-from-shell
    epc
    elpy
    jedi 
    jedi-direx
    zenburn-theme
    ido-vertical-mode
    flycheck
    python-environment
    auto-complete
    erlang
    solarized-theme
    cedet
    eieio
    semantic
    speedbar    
    ecb
    ein ;; add the ein package (Emacs ipython notebook)
    smartparens
    smart-tabs-mode
    python-mode
;;    python-django
    ;; ack-and-a-half 
    auctex
    ;; clojure-mode
    coffee-mode
    deft
    expand-region
    gist
    groovy-mode
    haml-mode
    haskell-mode
    inf-ruby
    magit ;; Git Integration (Magit)
    markdown-mode
    monokai-theme
    org
    paredit
    py-autopep8
    projectile
    python
    sass-mode
    rainbow-mode
    scala-mode
    scss-mode
    solarized-theme              
    volatile-highlights
    yaml-mode
    yari zenburn-theme)
  "A list of packages to ensure are installed at launch.")

;; ac-dabbrev 
;;    pyflakes
;;    pep8 
;;    pyflakes
;; python-info
;; magit
;; magithub
;;(exec-path-from-shell use-package yari yaml-mode volatile-highlights scss-mode scala-mode rainbow-mode sass-mode projectile paredit monokai-theme markdown-mode inf-ruby haskell-mode haml-mode groovy-mode gist expand-region deft coffee-mode auctex python-django python-mode smart-tabs-mode smartparens ecb solarized-theme erlang flycheck ido-vertical-mode zenburn-theme jedi-direx jedi elpy epc virtualenvwrapper virtualenv)))

(provide 'prelude-packages)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t) ;; https://melpa.org/#/getting-started
  (add-to-list
   'package-archives
   '("org" . "http://orgmode.org/elpa/")
   )
;;  (add-to-list
;;   'package-archives
;;   '("elpy" . "https://jorgenschaefer.github.io/packages/")
;;   )
  (package-initialize))

;; install any packages in my-packages, if they are not installed already
(let ((refreshed nil))
  (when (not package-archive-contents)
    (package-refresh-contents)
    (setq refreshed t))
  (dolist (pkg my-packages)
    (when (and (not (package-installed-p pkg))
             (assoc pkg package-archive-contents))
      (unless refreshed
        (package-refresh-contents)
        (setq refreshed t))
      (package-install pkg))))

(defun package-list-unaccounted-packages ()
  "Like `package-list-packages', but shows only the packages that
  are installed and are not in `my-packages'.  Useful for
  cleaning out unwanted packages."
  (interactive)
  (package-show-package-list
   (remove-if-not (lambda (x) (and (not (memq x my-packages))
                            (not (package-built-in-p x))
                            (package-installed-p x)))
                  (mapcar 'car package-archive-contents))))

;;; prelude-packages.el ends here

(message "INFO: .emacs: setup: Packages setup")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Include files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Some file locations are relative to the HOME or the BIN directory
(defvar use-home)
(setq use-home (concat (expand-file-name "~") "/"))

(defvar emacs-d-dir)
(setq emacs-d-dir (concat (expand-file-name use-home) ".emacs.d"))

(defvar elisp-dir)
(setq elisp-dir (concat (expand-file-name emacs-d-dir) "/lisp"))

;; Tell emacs where is your personal elisp lib dir
;; this is default dir for extra packages
(add-to-list 'load-path elisp-dir)

(defun my-file-exists-p (filename)
  (if (file-exists-p filename)
      (load-file filename)
    (ding)                                              ; From here on is the "else"
    (message "File does not exist: `%s'" (filename))
    )
  )

(defvar key-bindings (concat elisp-dir "/key-bindings.el"))
(my-file-exists-p key-bindings)
 
(defvar my-virtualenvwrapper (concat elisp-dir "/my-virtualenvwrapper.el"))
(my-file-exists-p my-virtualenvwrapper)

(message "INFO: .emacs: setup: Include files")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Requires
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'epc)
(require 'jedi)

;; Common Lisp package - for elisp auto completion and other features
(require 'cl) 

(message "INFO: .emacs: setup: requires")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cl-lib
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (add-to-list 'load-path "/home/depappas/.emacs.d/cl-lib/")
;; (require 'cl-lib)

;; (if (file-exists-p "/opt/emacs/emacs/emacs/lisp/emacs-lisp/cl-seq.el")
;;    (load-file "/opt/emacs/emacs/emacs/lisp/emacs-lisp/cl-seq.el"))

;; (require 'cl-seq)

;; (message "INFO: .emacs: setup: cl-lib setup")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Jedi setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Jedi
(require 'epc)
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook (lambda () (jedi:setup) ))

(setq jedi:complete-on-dot t)

(message "INFO: .emacs: setup: jedi")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Themes
;;
;; load one of the theme variants with M-x load-theme.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-theme 'zenburn t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ido vertical mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)

(message "INFO: .emacs: loaded: ido")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck syntax checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'after-init-hook #'global-flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smartparens mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (show-smartparens-global-mode +1)

(require 'smartparens-config)
(require 'smartparens-html)
(add-hook 'prog-mode-hook #'smartparens-mode)
(add-hook 'yaml-mode-hook #'smartparens-mode)

;; https://github.com/Fuco1/smartparens/issues/77
;; Smartparens allows you to automatically escape string quotation marks inside strings.
;; This is handy, but smartparens has a known bug: https://github.com/Fuco1/smartparens/issues/77
;; Instead, we simply switch off this behaviour.

(setq sp-autoescape-string-quote nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load the elisp files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun prepend-path ( my-path )
(setq load-path (cons (expand-file-name my-path) load-path)))
 
(defun append-path ( my-path )
(setq load-path (append load-path (list (expand-file-name my-path)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load the elisp files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

( append-path "~/emacs")

(message "INFO: .emacs: setup: path")

 
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; add more hooks here
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(put 'downcase-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(package-selected-packages
   (quote
    (exec-path-from-shell zenburn-theme yari yaml-mode volatile-highlights virtualenvwrapper virtualenv solarized-theme smartparens smart-tabs-mode scss-mode scala-mode sass-mode rainbow-mode python-mode python-django projectile paredit monokai-theme markdown-mode jedi-direx inf-ruby ido-vertical-mode haskell-mode groovy-mode gist flycheck expand-region erlang elpy ecb deft coffee-mode auctex)))
 '(show-paren-mode t)
 '(transient-mark-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To ensure Java recognition in Emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (setq auto-mode-alist
         (cons '("\\.java$" . java-mode) 
    auto-mode-alist))
   
   (setq interpreter-mode-alist
        (cons '("java" . java-mode)
    interpreter-mode-alist))

(defun my-c-mode-hook ()
  (setq c-basic-offset 4))
(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(message "INFO: .emacs: setup: c-mode-hooks")

(setq auto-mode-alist
      (append '(("\\.st$"  . html-mode)
		) auto-mode-alist))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Load the ctags file
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (file-exists-p "~/emacs/vtags.el")
    (load-file "~/emacs/vtags.el"))
(put 'upcase-region 'disabled nil)

(message "INFO: .emacs: setup: c-tags")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Autocomplete
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete)  
(global-auto-complete-mode t)

(message "INFO: .emacs: setup: auto-complete")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the indents
;; http://www.emacswiki.org/emacs/SmartTabs#Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(smart-tabs-insinuate 'c 'python)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For python.el, add
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(smart-tabs-advice python-indent-line-1 python-indent)
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width (default-value 'tab-width))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For python-mode.el, add
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(smart-tabs-advice py-indent-line py-indent-offset)
(smart-tabs-advice py-newline-and-indent py-indent-offset)
(smart-tabs-advice py-indent-region py-indent-offset)


(message "INFO: .emacs: setup: python-hooks")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; If you don't customize python-guess-indent by setting it to nil, 
;; ;; then python.el will automatically set python-indent for each Python buffer 
;; ;; (that contains indented text), making your python-indent customization ineffective. 
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; (custom-set-variables
;;  '(python-guess-indent nil)
;;  '(python-indent 2))
;; 
(message "INFO: .emacs: setup: python-indent")

;;; Commentary:

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(if (file-exists-p "~/.emacs_custom")
    (load-file "~/.emacs_custom"))
 
 (global-font-lock-mode t)


(provide `.emacs)
;;; .emacs ends here

(add-to-list 'load-path "~/.emacs.d/macros/")


;; https://sites.google.com/site/xiangyangsite/home/technical-tips/linux-unix/emacs/emacs-cscope

;; https://github.com/purcell/exec-path-from-shell
;;This sets $MANPATH, $PATH and exec-path from your shell, but only on OS X and Linux.


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python virtualenv 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(exec-path-from-shell-copy-env "PYTHONPATH")

(setq venv-location (expand-file-name "~/python_virtual_env"))   ;; Change with the path to your virtualenvs
;; Used python-environment.el and by extend jedi.el
(setq python-environment-directory venv-location)

(message "INFO: .emacs: setup: venv (python virtualenv)")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck syntax checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://realpython.com/blog/python/emacs-the-best-python-editor/

(package-initialize)
(elpy-enable)

(message "INFO: .emacs: setup: elpy-enable")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck syntax checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(add-hook 'python-mode-hook 'elpy-mode)

(message "INFO: .emacs: setup: flycheck")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pep8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(message "INFO: .emacs: setup: pep8")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ipython
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(elpy-use-ipython)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Old
;; Remove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ECB setup
;; http://stackoverflow.com/questions/9998202/first-steps-after-activating-ecb-first-time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fix me ;;  (require 'semantic/analyze)
;; fix me ;;  (provide 'semantic-analyze)
;; fix me ;;  (provide 'semantic-ctxt)
;; fix me ;;  (provide 'semanticdb)
;; fix me ;;  (provide 'semanticdb-find)
;; fix me ;;  (provide 'semanticdb-mode)
;; fix me ;;  (provide 'semantic-load)
;; fix me ;;  (semantic-mode 1)
;; fix me ;;   
;; (require 'ecb)
;; (require 'ecb-autoloads)
;; 
;; (setq ecb-auto-activate 1) 
;; ;; fix me ;; (ecb-winman-winring-enable-support)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; (require 'transpar)
;; (global-set-key (kbd "C-c C-x") 'transpose-paragraph-as-table)
;; 
;; (message "INFO: .emacs: setup: transpar")
;;


;;;;;;;----------------------------------------------------------

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Load the scala files
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Fix me ;; (add-to-list 'load-path "~/.emacs.d/site-lisp/scala-emacs")
;; Fix me ;; (require 'scala-mode-auto)
;; Fix me ;; 
;; Fix me ;; (add-hook 'scala-mode-hook
;; Fix me ;;             '(lambda ()
;; Fix me ;; 	       (scala-mode-feature-electric-mode)
;; Fix me ;;                ))
;; Fix me ;; 
;; Fix me ;; ;; load ensime for scala
;; Fix me ;; 
;; Fix me ;; (require 'scala-mode)
;; Fix me ;; (add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
;; Fix me ;; (add-to-list 'load-path "~/.emacs.d/site-lisp/ensime/elisp/")
;; Fix me ;; (require 'ensime)
;; Fix me ;; (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; Fix me ;; 
;; Fix me ;; ;; enable ensime
;; Fix me ;; 
;; Fix me ;; ;; (push "/media/data/tools/scala/scala/bin/" exec-path)
;; Fix me ;; ;; (push "/media/data/tools/sbt/" exec-path)
;; Fix me ;; 
;; Fix me ;; (push "/Applications/typesafe-stack/bin" exec-path)
;; Fix me ;; (push "/opt/homebrew/bin/sbt" exec-path)
;; Fix me ;; 
;; Fix me ;; ;; Erlang-mode
;; Fix me ;; (require 'erlang-start)
;; Fix me ;; (add-to-hook 'erlang-mode-hook
;; Fix me ;;              (lambda ()
;; Fix me ;;             ;; when starting an Erlang shell in Emacs, the node name
;; Fix me ;;             ;; by default should be "emacs"
;; Fix me ;;             (setq inferior-erlang-machine-options '("-sname" "emacs"))
;; Fix me ;;             ;; add Erlang functions to an imenu menu
;; Fix me ;;             (imenu-add-to-menubar "imenu")))
;; Fix me ;; 
;; Fix me ;; 

;;------------------------------------------------------------------------------

;; (add-to-list 'load-path (expand-file-name "~/emacs/site/jde/lisp"))

;; (add-to-list 'load-path (expand-file-name "/opt/emacs/emacs/emacs/lisp"))

;;( add-to-list 'load-path (expand-file-name "/opt/emacs/emacs/emacs/lisp/emacs-lisp"))

;;(require 'dabbrev)
;;(setq dabbrev-always-check-other-buffers t)
;;(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")
 
;;(global-set-key "\C-i" 'my-tab)
 
;; (defun my-tab (&optional pre-arg)
;;   "If preceeding character is part of a word then dabbrev-expand,
;; else if right of non whitespace on line then tab-to-tab-stop or
;; indent-relative, else if last command was a tab or return then dedent
;; one step, else indent 'correctly'"
;;   (interactive "*P")
;;   (cond ((= (char-syntax (preceding-char)) ?w)
;;          (let ((case-fold-search t)) (dabbrev-expand pre-arg)))
;;         ((> (current-column) (current-indentation))
;;          (indent-relative))
;;         (t (indent-according-to-mode)))
;;   (setq this-command 'my-tab))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Using tj3 with Org mode
;; To activate the Taskjuggler exporter in Org-mode, add this line to ~/.emacs:
;; http://orgmode.org/worg/org-tutorials/org-taskjuggler.html
;;http://www.taskjuggler.org/
;;
;; Copy this file :
;; http://orgmode.org/w/?p=org-mode.git;a=blob_plain;f=contrib/lisp/ox-taskjuggler.el;hb=HEAD
;; or
;; https://github.com/exu/emacs.d/blob/master/elpa/org-plus-contrib-20130826/ox-taskjuggler.el
;; to
;; ~/emacs.d/lisp/ox-taskjuggler.el
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(load-library "ox-taskjuggler.el")
;;(add-to-list 'org-export-backends 'taskjuggler)
