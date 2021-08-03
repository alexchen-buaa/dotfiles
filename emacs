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
	     '(font . "Monaco-14"))
;; add PATH
;; (emacs is like a terminal on it's own,
;; additional PATHs should be informed by the user)
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin:/Users/alexchen/anaconda3/bin:/Library/TeX/texbin"))
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("/Users/alexchen/anaconda3/bin")))
(setq exec-path (append exec-path '("/Library/TeX/texbin")))

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
  :bind ((:map evil-normal-state-map
	       ("C-t" . vterm))
	 (:map evil-normal-state-map
	       ("C-n" . neotree-toggle))
	 (:map evil-normal-state-map
	       ("TAB" . org-cycle)))
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

;; neotree for dir navigation
(use-package neotree
  :ensure t)

;; navigate like vim-tmux-navigator
(use-package tmux-pane
  :ensure t
  :config
  (tmux-pane-mode))

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
  :ensure t)
(use-package all-the-icons
  :ensure t
  :config
  (setq all-the-icons-ivy-buffer-commands '(counsel-find-file)))
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))
(load-theme 'doom-tomorrow-night t)

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

;; undo-tree
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree)) ; configure it like this

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
;; emacs ipython notebook (ein)
(use-package ein
  :ensure t)

;; AUCTeX (TeX integration)
;; it seems like the package hates use-package (
;; but I guess a few other related packages works

;; add xelatex support, the auctex config is slightly different
;; from the built-in latex-mode setup
(setq TeX-command-list
      '(("XeLaTeX" "xelatex -interaction nonstopmode %t" TeX-run-TeX nil
	 (latex-mode doctex-mode)
	 :help "Run XeLaTeX")
	("TeX" "%(PDF)%(tex) %(file-line-error) %`%(extraopts) %S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
	 (plain-tex-mode ams-tex-mode texinfo-mode)
	 :help "Run plain TeX")
	("LaTeX" "xelatex -interaction nonstopmode %t" TeX-run-TeX nil
	 (latex-mode doctex-mode)
	 :help "Run LaTeX")
	("Makeinfo" "makeinfo %(extraopts) %t" TeX-run-compile nil
	 (texinfo-mode)
	 :help "Run Makeinfo with Info output")
	("Makeinfo HTML" "makeinfo %(extraopts) --html %t" TeX-run-compile nil
	 (texinfo-mode)
	 :help "Run Makeinfo with HTML output")
	("AmSTeX" "amstex %(PDFout) %`%(extraopts) %S%(mode)%' %t" TeX-run-TeX nil
	 (ams-tex-mode)
	 :help "Run AMSTeX")
	("ConTeXt" "%(cntxcom) --once --texutil %(extraopts) %(execopts)%t" TeX-run-TeX nil
	 (context-mode)
	 :help "Run ConTeXt once")
	("ConTeXt Full" "%(cntxcom) %(extraopts) %(execopts)%t" TeX-run-TeX nil
	 (context-mode)
	 :help "Run ConTeXt until completion")
	("BibTeX" "bibtex %s" TeX-run-BibTeX nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode context-mode)
	 :help "Run BibTeX")
	("Biber" "biber %s" TeX-run-Biber nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Run Biber")
	("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer")
	("Print" "%p" TeX-run-command t t :help "Print the file")
	("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command)
	("File" "%(o?)dvips %d -o %f " TeX-run-dvips t
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Generate PostScript file")
	("Dvips" "%(o?)dvips %d -o %f " TeX-run-dvips nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Convert DVI file to PostScript")
	("Dvipdfmx" "dvipdfmx %d" TeX-run-dvipdfmx nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Convert DVI file to PDF with dvipdfmx")
	("Ps2pdf" "ps2pdf %f" TeX-run-ps2pdf nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Convert PostScript file to PDF")
	("Glossaries" "makeglossaries %s" TeX-run-command nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Run makeglossaries to create glossary
	file")
	("Index" "makeindex %s" TeX-run-index nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Run makeindex to create index file")
	("upMendex" "upmendex %s" TeX-run-index t
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Run upmendex to create index file")
	("Xindy" "texindy %s" TeX-run-command nil
	 (plain-tex-mode latex-mode doctex-mode ams-tex-mode texinfo-mode)
	 :help "Run xindy to create index file")
	("Check" "lacheck %s" TeX-run-compile nil
	 (latex-mode)
	 :help "Check LaTeX file for correctness")
	("ChkTeX" "chktex -v6 %s" TeX-run-compile nil
	 (latex-mode)
	 :help "Check LaTeX file for common mistakes")
	("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document")
	("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files")
	("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files")
	("Other" "" TeX-run-command t t :help "Run an arbitrary command")))
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
  (setq org-hide-leading-stars t)
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c C-w") 'org-refile)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
				 (file+headline "~/local/org/inbox.org" "Inbox")
				 "* TODO %i%?")
				("u" "Todo [upnext]" entry
				 (file+headline "~/local/org/upnext.org" "Upnext")
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
			     ("~/local/org/inbox.org" :maxlevel . 3)
			     ("~/local/org/project.org" :maxlevel . 3)
			     ("~/local/org/schedule.org" :maxlevel . 2)
			     ("~/local/org/someday.org" :level . 1)))
  (setq org-tag-alist '(("casual" . ?c)
			("serious" . ?s)
			("requested" . ?r)
			("scheduled" . ?S)
			("life" . ?l))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#c9b4cf" "#8abeb7" "#c5c8c6"])
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   '("bf387180109d222aee6bb089db48ed38403a1e330c9ec69fe1f52460a8936b66" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "6c9cbcdfd0e373dc30197c5059f79c25c07035ff5d0cc42aa045614d3919dab4" "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9" "5036346b7b232c57f76e8fb72a9c0558174f87760113546d3a9838130f1cdb74" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "d0aa1464d7e55d18ca1e0381627fac40229b9a24bca2a3c1db8446482ce8185e" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "454c1c9ce70f7d807c51c890910365fd3c64a9e63f596511e9ff57dd97bbeea8" "801a567c87755fe65d0484cb2bded31a4c5bb24fd1fe0ed11e6c02254017acb2" "e72f5955ec6d8585b8ddb2accc2a4cb78d28629483ef3dcfee00ef3745e2292f" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "188fed85e53a774ae62e09ec95d58bb8f54932b3fd77223101d036e3564f9206" "4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" "6b80b5b0762a814c62ce858e9d72745a05dd5fc66f821a1c5023b4f2a76bc910" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee" "5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "d4131a682c4436bb5a61103d9a850bf788cbf793f3fd8897de520d20583aeb58" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "6084dce7da6b7447dcb9f93a981284dc823bab54f801ebf8a8e362a5332d2753" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" default))
 '(fci-rule-color "#5c5e5e")
 '(helm-ag-base-command "rg --no-heading")
 '(helm-ag-success-exit-status '(0 2))
 '(helm-completion-style 'emacs)
 '(helm-minibuffer-history-key "M-p")
 '(helm-mode t)
 '(jdee-db-active-breakpoint-face-colors (cons "#0d0d0d" "#81a2be"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d0d0d" "#b5bd68"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d0d0d" "#5a5b5a"))
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(objed-cursor-color "#cc6666")
 '(package-selected-packages
   '(tmux-pane neotree ein undo-tree company-anaconda anaconda-mode company-auctex auctex vterm yasnippet-snippets flycheck evil-nerd-commenter linum-relative evil-collection magit evil-leader all-the-icons-ivy-rich all-the-icons-ivy counsel ivy company tron-legacy-theme doom-themes all-the-icons tao-theme evil-visual-mark-mode eziam-theme evil))
 '(pdf-view-midnight-colors (cons "#c5c8c6" "#1d1f21"))
 '(rustic-ansi-faces
   ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#c9b4cf" "#8abeb7" "#c5c8c6"])
 '(vc-annotate-background "#1d1f21")
 '(vc-annotate-color-map
   (list
    (cons 20 "#b5bd68")
    (cons 40 "#c8c06c")
    (cons 60 "#dcc370")
    (cons 80 "#f0c674")
    (cons 100 "#eab56d")
    (cons 120 "#e3a366")
    (cons 140 "#de935f")
    (cons 160 "#d79e84")
    (cons 180 "#d0a9a9")
    (cons 200 "#c9b4cf")
    (cons 220 "#ca9aac")
    (cons 240 "#cb8089")
    (cons 260 "#cc6666")
    (cons 280 "#af6363")
    (cons 300 "#936060")
    (cons 320 "#765d5d")
    (cons 340 "#5c5e5e")
    (cons 360 "#5c5e5e")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
