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

(set-frame-font "Berkeley Mono 14")

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
  ;(ef-themes-select 'ef-bio)
  ;(ef-themes-select 'ef-dream)
  ;(ef-themes-select 'ef-melissa-dark)
  )

(use-package modus-themes
  :ensure t
  :config
  ;(modus-themes-select 'modus-vivendi)
  )

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t)
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
  
