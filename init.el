;; Emacs Configurations
;; By: Raymond Wan
;; Inspiration from
;; https://ogbe.net/emacsconfig.html 
;; https://gitlab.com/buildfunthings/emacs-config/blob/master/loader.org
;; http://pages.sachachua.com/.emacs.d/Sacha.html

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
(global-set-key (kbd "C-c I") (lambda () (interactive) (find-file-other-window user-init-file)))

;; Move the custom.el stuff into it's own file
;; I don't want to litter this file
(setq custom-file "~/.emacs.d/lisp/customize.el")
(load custom-file)

(set-default-font "Source Code Pro 13")

;; Allow window movement using Shift+Arrow keys
(windmove-default-keybindings)

;; Remove toolbar and scrollbar
(tool-bar-mode -1)
(toggle-scroll-bar -1) 

;; https://www.emacswiki.org/emacs/LineNumbers
;; NOTE: Apparently there's a dumb behaviour by enabling line numbering like this
;; (global-linum-mode 1)

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

;; PACKAGES 
(require 'use-package)

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config
  (progn
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)
    (global-undo-tree-mode)))
  
(use-package evil
  :ensure t
  :init (setq evil-want-C-u-scroll t)
  :config
  (progn 
    (evil-mode 1)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)))

(use-package powerline
  :ensure t
  :config
  (setq powerline-arrow-shape 'curve))

(use-package moe-theme 
  :ensure t
  :config
  (progn
    (powerline-moe-theme)
    (moe-dark)
    (moe-theme-set-color 'orange)
    (setq moe-theme-highlight-buffer-id t)))


(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook
	    (lambda()
	      (rainbow-delimiters-mode))))

(use-package magit
  :ensure t
  :config (global-set-key (kbd "C-x g") 'magit-status))

(use-package nlinum
  :ensure t
  :config
    (global-nlinum-mode 1))

(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (helm-mode))
  :bind (("M-x" . helm-M-x)))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p"))
    (setq projectile-completion-system 'helm)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'alien)
    (projectile-global-mode)))

;; https://tuhdo.github.io/helm-projectile.html
(use-package helm-projectile
  :ensure t
  :config (helm-projectile-on))

;; Fix this 
;; http://emacs.1067599.n8.nabble.com/Sorry-no-version-of-R-could-be-found-on-your-system-R-x64-2-11-0-on-windows-td238052.html
;; (use-package ess
;;   :ensure t
;;   :init
;;   (setq-default inferior-R-args "--no-save "))

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
  :config
  (progn
    (setq-default left-fringe-width 3)
    (global-git-gutter-mode 1)
    ;; Using a minimalistic style from https://github.com/hlissner/.emacs.d
    (define-fringe-bitmap 'git-gutter-fr:added
	[224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
	nil nil 'center)
    (define-fringe-bitmap 'git-gutter-fr:modified
	[224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
	nil nil 'center)
    (define-fringe-bitmap 'git-gutter-fr:deleted
	[0 0 0 0 0 0 0 0 0 0 0 0 0 128 192 224 240 248]
	nil nil 'center)))
