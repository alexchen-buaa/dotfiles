;;;; alexchen's emacs config

;;; general guidelines for emacs-vim integration

;; 1. bring modal editing to emacs
;; which means that vim-style editing commmands, including
;; yy, dd, $, and <leader>-related bindings are fulfilled using evil
;; 2. preserve the good things in emacs
;; keep the extended bindings/commands, elisp, official package managing
;; and more (the emacs ways of doing these things are generally better
;; organized than vim/neovim)

;;; basics (for builtins)

;; do not show startup screen
(setq inhibit-startup-message t)
;; disable toolbar, menubar, scrollbar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; display line numbers
(global-display-line-numbers-mode)
;; default font, window size
(add-to-list 'default-frame-alist
	     '(font . "PragmataPro-14"))
;; add PATH
;; (emacs is like a terminal on it's own,
;; additional PATHs should be informed by the user)
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin:/Users/alexchen/anaconda3/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("/Users/alexchen/anaconda3/bin")))

;;; package manager (package and use-package)

;; package
(require 'package)
(add-to-list 'package-archives '("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/"))
(add-to-list 'package-archives '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
(add-to-list 'package-archives '("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/"))
(add-to-list 'package-archives '("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; use-package (bootstrap)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; **CAUTION**
;; these are the major keywords used in use-package:
;; :init <code to be executed before loading the package>
;; :config <code to be executed before loading the package>
;; :bind <key bindings for this package>
;; of course you can use global-set-key, like:
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; for tidiness, use :bind instead
;; to remove packages, do M-x package-delete

;;; interface enhancement

;; evil (I'm more of a vim user)
(use-package evil-leader ; let there be <leader>
  :ensure t
  :init (setq evil-want-keybinding nil)
  :config
  (evil-leader/set-leader ",")
  ;; avy
  (evil-leader/set-key
    ", w" 'avy-goto-word-0-below
    ", b" 'avy-goto-word-0-above
    ", j" 'avy-goto-line-below
    ", k" 'avy-goto-line-above)
  ;; evil-nerd-commenter
  (evil-leader/set-key "cc" 'evilnc-comment-or-uncomment-lines)
  (global-evil-leader-mode))
(use-package evil
  :ensure t
  :init (setq evil-want-keybinding nil)
  :bind (:map evil-normal-state-map
	      ("C-t" . vterm))
  :config (evil-mode 1))
(use-package evil-collection ; evil bindings everywhere
  :after evil
  :ensure t
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

;; ivy (quick and easy selection from a list)
(use-package ivy
  :ensure t
  :bind ("C-c C-r" . ivy-resume)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (ivy-mode 1))
;; ivy-related packages
(use-package counsel ; for completing emacs commands
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :config
  ;; for counsel-rg to operate correctly, specify the command
  (setq counsel-rg-base-command
	"rg --with-filename --no-heading --line-number --path-separator / --color never %s .")
  (counsel-mode t))
(use-package swiper ; for searching
  :ensure t
  :bind ("C-s" . swiper))
(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))
(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

;; linum-relative
(use-package linum-relative
  :ensure t
  :config
  (setq linum-relative-backend 'display-line-numbers-mode)
  (linum-relative-mode))

;; packages needed for a modern-looking emacs
;; notice that doom-related packages intended to
;; use a different font in tabbars and etc. (inspired by atom)
;; let's use a geekier font
;; color themes
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (doom-themes-org-config))
(use-package tron-legacy-theme
  :ensure t
  :config
  (load-theme 'tron-legacy t))
(use-package all-the-icons
  :ensure t
  :config
  (setq all-the-icons-ivy-buffer-commands '(counsel-find-file)))
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))

;;; editing features (navigation, completion...)

;; avy (like vim-easymotion)
(use-package avy
  :ensure t
  :config
  (avy-setup-default))

;; evil-nerd-commenter (a classic tool in vim)
(use-package evil-nerd-commenter
  :ensure t)

;; company (inline autocompletion)
(use-package company
  :ensure t
  :init ; this has to be init, otherwise it won't be automatic
  (add-hook 'after-init-hook 'global-company-mode)
  :bind
  (:map company-active-map
	("C-n" . company-select-next)
	("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0)
  (eval-after-load "company"
    '(add-to-list 'company-backends 'company-anaconda))
  (global-company-mode t))

;; flycheck (linting)
(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; yasnippet (snippets)
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets
  :ensure t)

;;; integration (with other tools and languages)


;; magit (interface to git)
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; vterm (terminal integration)
(use-package vterm
  :ensure t)

;; python support (using anaconda-mode)
(use-package anaconda-mode
  :ensure t
  :init (add-hook 'python-mode-hook 'anaconda-mode))
(use-package company-anaconda
  :ensure t)

;; AUCTeX (TeX integration)
;; it seems like the package hates use-package (
;; but I guess a few other related packages works
(use-package company-auctex
  :ensure t)

;;; org-mode config

;; I chose to learn org-mode for GTD methology.
;; of course org-mode can be used as a efficient note/journal tool.

;; my GTD files include:
;; inbox.org: for collection
;; project.org: for processing multi-stage tasks
;; schedule.org: for keeping single-stage scheduled tasks
;; someday.org: for keeping tasks that require incubation
;; upnext.org: for next actions

;; there are a few non-GTD org files for now...
;; note.org: for keeping some scattered notes about everything
;; journal.org: for keeping some thoughts that comes and goes

;; for tidiness, capture only goes into inbox, note or journal
;; multi-stage tasks are refiled into project
;; single-stage tasks are refiled into schedule
;; other things goes either into someday or upnext
(use-package org
  :config
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c C-w") 'org-refile)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
				 (file+headline "~/local/org/inbox.org" "Tasks")
				 "* TODO %i%?")
				("n" "Note" entry
				 (file+headline "~/local/org/note.org" "Notes")
				 "* %i%?")
				("j" "Journal" entry
				(file+headline "~/local/org/journal.org" "Journals")
				 "* Entered on %U\n  %i%?")))
  (setq org-agenda-files '("~/local/org/upnext.org"
			   "~/local/org/schedule.org"))
  (setq org-refile-targets '(("~/local/org/upnext.org" :maxlevel . 3)
			     ("~/local/org/project.org" :maxlevel . 3)
			     ("~/local/org/schedule.org" :maxlevel . 2)
			     ("~/local/org/someday.org" :level . 1)))
  (setq org-tag-alist '(("study" . ?s)
			("life" . ?l))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "d4131a682c4436bb5a61103d9a850bf788cbf793f3fd8897de520d20583aeb58" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "6084dce7da6b7447dcb9f93a981284dc823bab54f801ebf8a8e362a5332d2753" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" default))
 '(helm-ag-base-command "rg --no-heading")
 '(helm-ag-success-exit-status '(0 2))
 '(helm-completion-style 'emacs)
 '(helm-minibuffer-history-key "M-p")
 '(helm-mode t)
 '(package-selected-packages
   '(company-anaconda anaconda-mode company-auctex auctex vterm yasnippet-snippets flycheck evil-nerd-commenter linum-relative evil-collection magit evil-leader all-the-icons-ivy-rich all-the-icons-ivy counsel ivy company tron-legacy-theme doom-themes all-the-icons tao-theme evil-visual-mark-mode eziam-theme evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
