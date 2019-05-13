;; Emacs Configurations
;; By: Raymond Wan
;; Inspiration from
;; https://ogbe.net/emacsconfig.html
;; https://gitlab.com/buildfunthings/emacs-config/blob/master/loader.org
;; http://pages.sachachua.com/.emacs.d/Sacha.html
;; https://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/

(require 'cl)
(require 'package)

(defvar gnu '("gnu" . "https://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "https://melpa.org/packages/"))
(defvar melpa-stable '("melpa-stable" . "https://stable.melpa.org/packages/"))

(setq package-archives nil)
(add-to-list 'package-archives melpa-stable t)
(add-to-list 'package-archives melpa t)
(add-to-list 'package-archives gnu t)
(package-initialize)

(unless (and (file-exists-p "~/.emacs.d/elpa/archives/gnu")
             (file-exists-p "~/.emacs.d/elpa/archives/melpa")
             (file-exists-p "~/.emacs.d/elpa/archives/melpa-stable"))
  (package-refresh-contents))

;; Load path for other packages
(add-to-list 'load-path "~/.emacs.d/lisp/")

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Shortcut to quickly access init.el (this file)
(global-set-key (kbd "C-c I") (lambda ()
				(interactive)
				(split-window-horizontally)
				(other-window 1)
				(find-file user-init-file)))

;; Move the custom.el stuff into it's own file
;; I don't want to litter this file
(setq custom-file "~/.emacs.d/lisp/customize.el")
(load custom-file)

(set-default-font "Hack 14")

;; Allow window movement using Shift+Arrow keys
(windmove-default-keybindings)

;; Remove toolbar and scrollbar
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; Stop Emacs from losing undo information by setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

;; Line numbering
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; Make scrolling smooth (Vim-like scrolling)
(setq scroll-step 1)
(setq scroll-conservatively 10000)

;; Disable the bell
(defun my-bell-function ())
(setq ring-bell-function 'my-bell-function)
(setq visible-bell nil)

;; Quick reloading of init.el
(eval-after-load "Emacs-Lisp"
  (define-key emacs-lisp-mode-map (kbd "C-c C-b") 'eval-buffer))

;; Focus to the new split after creating it
(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))

;; No line wrapping
(setq-default truncate-lines t)

;; Show matching parenthesis
(show-paren-mode t)

;; No backup files
(setq make-backup-files nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'use-package)
(require 'cc-mode)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

(use-package evil-leader
  :ensure t
  :config
  (progn
    (global-evil-leader-mode)
    (evil-leader/set-leader ",")
    (evil-leader/set-key
      "e" 'find-file
      "b" 'switch-to-buffer
      "k" 'kill-buffer)))

(use-package evil-search-highlight-persist
  :ensure t
  :config
  (progn
    (global-evil-search-highlight-persist t)))

(use-package evil
  :ensure t
  :init
  (progn
    (setq evil-want-C-u-scroll t)
    (setq evil-want-fine-undo t))
  :config
  (progn
    (evil-mode 1)
    (evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)
    (define-key evil-normal-state-map (kbd "C-p") 'helm-find-files)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)))

(use-package gruvbox-theme
  :ensure t)

;; (use-package magit
;;   :ensure t
;;   :config (global-set-key (kbd "C-x g") 'magit-status))

(use-package git-gutter
  :ensure t
  :config
    (global-git-gutter-mode +1))

(use-package powerline
  :ensure t
  :config
    (powerline-center-evil-theme))

(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (progn
    (helm-mode 1))
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HOOKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'before-save-hook 'delete-trailing-whitespace)

; Map escape to cancel (like C-g)...
(define-key isearch-mode-map [escape] 'isearch-abort)   ;; isearch
(define-key isearch-mode-map "\e" 'isearch-abort)   ;; \e seems to work better for terminals
(global-set-key [escape] 'keyboard-escape-quit)         ;; everywhere else

;; Start fullscreen
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
