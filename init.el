;; Raymond Wan's Emacs Configuration

(require 'package)
(setq package-archives '(("melpa". "https://melpa.org/packages/")
                         ("melpa-stable". "https://stable.melpa.org/packages/")
                         ("gnu". "https://elpa.gnu.org/packages/")))
(unless package-archive-contents
  (package-refresh-contents))

;; Load path for other packages
(add-to-list 'load-path "~/.emacs.d/lisp/")
(setq custom-file (locate-user-emacs-file "custom-vars.el"))

(tool-bar-mode -1)
(scroll-bar-mode -1)

(if (not (eq system-type 'darwin))
    (menu-bar-mode pp-1))

(global-display-line-numbers-mode 1)
(column-number-mode t)
(pixel-scroll-precision-mode t)
(global-auto-revert-mode t)
(show-paren-mode t)

(setq visible-bell nil)
(setq ring-bell-function 'ignore)

(load-theme 'modus-operandi-tinted t)
(set-frame-font "Berkeley Mono 14" nil t)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Put in ~/.emacs.d/lisp/
;; https://github.com/Kitware/CMake/blob/master/Auxiliary/cmake-mode.el
(require 'cmake-mode)

(defun my-c-mode-hook ()
  (setq c-default-style "bsd"
        c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package markdown-mode
  :ensure t) 
