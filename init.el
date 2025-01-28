;; Raymond Wan's Emacs Configuration
;; Written for Emacs 29

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless (file-exists-p "~/.emacs.d/elpa")
  (package-refresh-contents))

;; Load path for other packages
(add-to-list 'load-path "~/.emacs.d/lisp/")
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)


(if (eq system-type 'darwin)
    (set-frame-font "Berkeley Mono 14")
  (set-frame-font "Berkeley Mono 11"))
  
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(column-number-mode t)
(global-display-line-numbers-mode t)
(windmove-default-keybindings)
(pixel-scroll-precision-mode t)
(global-auto-revert-mode t)
(show-paren-mode t)
(global-auto-revert-mode t)

(setq mac-command-modifier 'meta)

(setq make-backup-files nil)
(setq global-auto-revert-non-file-buffers t)

;; Stop Emacs from losing undo information by setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

;; Make scrolling smooth (Vim-like scrolling)
(setq scroll-step 1)
(setq scroll-conservatively 10000)

;; No line wrapping
;;(setq-default truncate-lines t)

(setq undo-tree-auto-save-history nil)

(defun my-bell-function ())
(setq ring-bell-function 'my-bell-function)
(setq visible-bell nil)

(global-set-key (kbd "C-x 2") (lambda () (interactive) (split-window-horizontally) (other-window 1)))
(global-set-key (kbd "C-x 3") (lambda () (interactive) (split-window-vertically) (other-window 1)))
(global-set-key (kbd "C-c j") #'duplicate-dwim)

(global-hl-line-mode 1)

(global-unset-key "\C-z")
(global-set-key "\C-z" 'undo)

(global-unset-key "\M-c")

(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x C-q") 'save-buffers-kill-terminal)

(setq-default cursor-type 'bar)

(global-set-key (kbd "C-<tab>") 'dabbrev-expand)
(define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand)

(global-set-key [f12] (lambda () (interactive) (find-file user-init-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EDITING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (lua "https://github.com/tree-sitter-grammars/tree-sitter-lua")
        (make "https://github.com/alemuller/tree-sitter-make")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")    
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")
        ))

(setq major-mode-remap-alist
      '((sh-mode . bash-ts-mode)
        (c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        ;(Cmake-mode . cmake-ts-mode)
        (css-mode . css-ts-mode)
        (js2-mode . js-ts-mode)
        (json-mode . json-ts-mode)
        (lua-mode . lua-ts-mode)
        (python-mode . python-ts-mode)
        (ruby-mode . ruby-ts-mode)
        (python-mode . python-ts-mode)
	))

(add-hook 'c-ts-mode-hook
	  (lambda ()
	    (setq-local c-ts-mode-indent-style 'linux)
	    (setq-local c-ts-mode-indent-offset 4)))

(add-hook 'c++-ts-mode-hook
	  (lambda ()
	    (setq-local c-ts-mode-indent-style 'linux)
	    (setq-local c++-ts-mode-indent-style 'linux)
	    (setq-local c-ts-mode-indent-offset 4)
	    (setq-local c++-ts-mode-indent-offset 4)))

(add-to-list 'auto-mode-alist '("CmakeLists.txt" . cmake-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ef-themes
  :ensure t
  :config
  (ef-themes-select 'ef-bio)
  ;(ef-themes-select 'ef-dream)
  ;(ef-themes-select 'ef-melissa-dark)
  )

(use-package zenburn-theme
  :ensure t
  :config
  ;(load-theme 'zenburn t)
  )

(use-package modus-themes
  :ensure t
  :config
  ;(modus-themes-select 'modus-vivendi)
  )

(use-package catppuccin-theme
  :ensure t)

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window))

(use-package undo-tree
  :ensure t
  :config
    (global-undo-tree-mode))

(use-package all-the-icons
  :ensure t)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (progn
    (global-set-key [f8] 'treemacs)
    (with-eval-after-load 'winum
      (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
    (with-eval-after-load 'treemacs
      (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
    ))

(use-package magit
  :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package embark
  :ensure t
  :bind
   (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package consult
  :ensure t
  :bind
  (("C-x b" . consult-buffer)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; meow mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(use-package meow
  :ensure t
  :config
  (meow-setup)
  (meow-global-mode 1))
