;;; init.el --- yvnth's emacs config -*- lexical-binding: t; -*-

;;; Commentary:
;; Packages managed by Nix (emacs.nix).

;;; Code:

;; startup speed
(setq gc-cons-threshold (* 50 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))
            (message "up in %s" (emacs-init-time))))

;; theme
(use-package catppuccin-theme
  :demand t
  :config
  (setq catppuccin-flavor 'frappe)
  (load-theme 'catppuccin t))

;; ui cleanup
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(set-fringe-mode 10)

;; font
(set-frame-font "JetBrainsMono Nerd Font-18" nil t)
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-18"))

;; icon fallback
(when (display-graphic-p)
  (set-fontset-font t 'unicode "JetBrainsMono Nerd Font" nil 'append))

;; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

;; no beep
(setq ring-bell-function 'ignore)

;; backups and auto saves, moved out of project folders
(setq backup-directory-alist
      '(("." . "~/.ebt/backups")))
(setq auto-save-file-name-transforms
      '((".*" "~/.ebt/auto-saves/" t)))
(make-directory "~/.ebt/backups" t)
(make-directory "~/.ebt/auto-saves" t)

;; disable lock files
(setq create-lockfiles nil)

;; remember minibuffer history
(savehist-mode 1)

;; remember cursor position per file
(save-place-mode 1)

;; window padding
(use-package spacious-padding
  :demand t
  :config
  (setq spacious-padding-widths
        '(:internal-border-width 10
				 :header-line-width     2
				 :mode-line-width       2
				 :tab-width             2
				 :right-divider-width   12
				 :scroll-bar-width      4
				 :fringe-width          4))
  (spacious-padding-mode 1))

;; icons
(use-package all-the-icons
  :if (display-graphic-p))

;; colored matching parens
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; startup screen
(use-package dashboard
  :demand t
  :init
  (setq dashboard-center-content     t
        dashboard-banner-logo-title  "வணக்கம் yvnth"
        dashboard-startup-banner     "/home/yvnth/repos/nixmacs/assets/logo.png"
        dashboard-image-banner-max-width 400
        dashboard-items              nil
        initial-buffer-choice        (lambda () (get-buffer-create dashboard-buffer-name)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-insert-startupify-lists))

;; minibuffer completion ui
(use-package vertico
  :demand t
  :config
  (vertico-mode 1)
  (setq vertico-cycle t))

;; fuzzy completion filtering
(use-package orderless
  :demand t
  :config
  (setq completion-styles             '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

;; actions on completion candidates
(use-package embark
  :bind (("C-," . embark-act)
         ("C-." . embark-dwim)
         ("C-h B" . embark-bindings))
  :config
  (setq prefix-help-command #'embark-prefix-help-command))

;; embark + consult glue
(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; search and navigation commands
(use-package consult
  :bind (("C-s"     . consult-line)
         ("C-x b"   . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-g g"   . consult-goto-line)
         ("M-g e"   . consult-compile-error)
         ("M-s f"   . consult-find)
         ("M-s r"   . consult-ripgrep))
  :config
  (setq xref-show-xrefs-function       #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; completion candidate annotations
(use-package marginalia
  :demand t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :config (marginalia-mode 1))

;; keybinding hints
(use-package which-key
  :demand t
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0))

;; git
(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status))

;; docker
(use-package docker)

;; lsp performance
(setq read-process-output-max (* 1024 1024))

;; language server client
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-idle-delay 0.5)
  (setq lsp-completion-provider :none)
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-which-key-integration t))

(use-package lsp-ui :commands lsp-ui-mode)

;; syntax checking
(use-package flycheck
  :init
  (global-flycheck-mode))

;; auto format on save
(use-package apheleia
  :config
  (setf (alist-get 'nixfmt apheleia-formatters) '("nixfmt"))
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'nixfmt)
  (setf (alist-get 'python-mode apheleia-mode-alist) 'ruff)
  (setf (alist-get 'sh-mode apheleia-mode-alist) 'shfmt)
  (setf (alist-get 'dockerfile apheleia-formatters) '("dockerfmt"))
  (setf (alist-get 'dockerfile-mode apheleia-mode-alist) 'dockerfile)
  (setf (alist-get 'yamlfmt apheleia-formatters) '("yamlfmt" "-in"))
  (setf (alist-get 'yaml-mode apheleia-mode-alist) 'yamlfmt)
  (apheleia-global-mode +1))

;; auto close paranthesis except for org <s<TAB>
(electric-indent-mode 1)
(electric-pair-mode 1)

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local electric-pair-inhibit-predicate
                        (lambda (c)
                          (if (char-equal c ?<)
                              t
                            (electric-pair-default-inhibit c))))))

;; autocomplete popup
(use-package corfu
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.0
        corfu-auto-prefix 1
        corfu-cycle t))

;; debugger
(use-package dap-mode
  :after lsp-mode
  :bind (("C-c d d" . dap-debug)
         ("C-c d l" . dap-debug-last)
         ("C-c d b" . dap-breakpoint-toggle)
         ("C-c d c" . dap-continue)
         ("C-c d n" . dap-next)
         ("C-c d s" . dap-step-in)
         ("C-c d o" . dap-step-out)
         ("C-c d q" . dap-disconnect))
  :config
  (dap-auto-configure-mode 1)
  (require 'dap-python)
  (require 'dap-lldb)
  (require 'dap-go)
  (dap-go-setup))

;; nix
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))

;; go
(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred))

;; just
(use-package just-ts-mode
  :mode "\\(?:\\(?:^\\|/\\)[Jj]ustfile\\|\\.just\\)\\'"
  :config
  (just-ts-mode-install-grammar))

;; rust
(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp-deferred))

;; c, c++, only lsp
(add-hook 'c-mode-hook     'lsp-deferred)
(add-hook 'c++-mode-hook   'lsp-deferred)

;; dockerfile
(use-package dockerfile-mode
  :mode "Dockerfile\\'"
  :hook (dockerfile-mode . lsp-deferred))

;; bash
(add-hook 'sh-mode-hook 'lsp-deferred)

;; yaml
(use-package yaml-mode
  :mode "\\.ya?ml\\'"
  :hook (yaml-mode . lsp-deferred))

;; python
(use-package lsp-pyright
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))))

;; structural editing for parens
(use-package paredit
  :hook ((lisp-mode       . paredit-mode)
         (emacs-lisp-mode . paredit-mode)
         (scheme-mode     . paredit-mode)))

;; org mode, reveal markup under cursor
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks      t
        org-appear-autosubmarkers t
        org-appear-autoentities   t
        org-appear-autokeywords   t))

;; org tempo (<s<TAB>, <q<TAB>, etc.)
(require 'org-tempo)

;; justfile runner
(use-package justl
  :commands justl
  :custom
  (justl-executable "just"))

;; terminal
(use-package ghostel
  :commands (ghostel)
  :bind (("C-x m" . ghostel)))

;; per-project env vars via direnv
(use-package envrc
  :demand t
  :hook (after-init . envrc-global-mode))

;; dired, reuse buffer on navigation
(use-package dired
  :ensure nil
  :config
  (put 'dired-find-alternate-file 'disabled nil)
  (setq dired-kill-when-opening-new-dired-buffer t)
  :bind (:map dired-mode-map
              ("RET" . dired-find-alternate-file)
              ("^"   . (lambda () (interactive)
			 (find-alternate-file "..")))))

;;; init.el ends here
