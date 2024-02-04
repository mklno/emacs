;; moving compiled el files to a different directory
(setcar native-comp-eln-load-path "/home/mklno/.cache/eln-cache")

;; basic interface settings
(setq inhibit-startup-screen t)
(setq use-dialog-box nil)
(setq use-file-dialog nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode -1)
(scroll-bar-mode -1)
(global-subword-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)

;; themes
(load "~/.emacs.d/themes/sexy-monochrome-theme.el")
(load-theme 'sexy-monochrome t)

;; font
(add-to-list 'default-frame-alist
             '(font . "JetBrains Mono-10"))

;; melpa init
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; package manager
;; https://ianyepan.github.io/posts/setting-up-use-package/ 
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package-ensure)
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/misc/avatar.png")
  (setq dashboard-banner-logo-title "mklno@dostoevsky"))

;; loading custom variables - contains customize* options
(setq custom-file "~/.emacs.d/misc/custom.el")
(load custom-file)

;; move recent files from . to misc
(setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/misc/recentf"))

;; journal - added using require 
;; (load "~/.emacs.d/functions/ejournal.el")

;; interactive buffer 
(use-package ido-vertical-mode
  :config
  (setq ido-save-directory-list-file "~/.emacs.d/misc/ido.last")
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only)      
  :init
  (ido-mode 1)
  (ido-vertical-mode 1))

;; M-x enhanced
(use-package smex
  :init (smex-initialize)
  :config
  (setq smex-save-file "~/.emacs.d/misc/smex-items")	
  :bind
  ("M-x" . smex)) 

;; changing bookmarks location
(setq bookmark-default-file "~/.emacs.d/misc/bookmarks")

;; utf-8 changes
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; loading functions 
(add-to-list 'load-path "~/.emacs.d/functions/")

;; org bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook 'visual-line-mode)

;; journal
(require 'journal)

;;
(require 'wakatime-mode)
(global-wakatime-mode)
;; formatter
(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters '(("HTML" (prettier))
										("CSS" (prettier))
										("Javascript" (prettier))
										("Python" (black)))))
   
;; complete anything
(use-package company
  :defer t
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0)
  (add-hook 'after-init-hook 'global-company-mode))

;; python backend for company
(setq python-shell-interpreter "python3")
(use-package company-jedi
  :after company
  :config
  (add-to-list 'company-backends 'company-jedi))

;; lsp mode
(use-package lsp-mode
  :defer t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-headerline-breadcrumb-enable nil))

;; lsp ui
(use-package lsp-ui
  :defer t)

;; dap mode
(use-package dap-mode
  :after lsp-mode
  :defer t)

;; python lsp
(use-package lsp-pyright
  :defer t
  :hook (python-mode . (lambda ()
                         (setq indent-tabs-mode t)
                         (setq tab-width 4)
                         (setq python-indent-offset 4)
                         (company-mode 1)
						 (electric-pair-mode t)
                         (require 'lsp-pyright)
   						 (pyvenv-autoload)
                         (lsp))))

;; python env
(use-package pyvenv
  :defer t)
;; emmet mode
(use-package emmet-mode
  :defer t)

;; web mode
(use-package web-mode
  :defer t
  :config
  (setq
   web-mode-markup-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-code-indent-offset 2
   web-mode-style-padding 2
   web-mode-script-padding 2
   web-mode-enable-auto-closing t
   web-mode-enable-auto-opening t
   web-mode-enable-auto-pairing t
   web-mode-enable-auto-indentation t)
  :mode
  (".html$" "*.php$" "*.tsx"))

;; wakatime

