(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; Appearance
(tool-bar-mode -1) ; no tool bar
(scroll-bar-mode -1) ; no scroll bar
(global-linum-mode 0)

;; Basic functionality
(require 'evil)
(require 'multi-term)
(require 'key-chord)

(evil-mode 1)
(key-chord-mode 1)
(company-mode 1)

(add-hook 'text-mode-hook 'auto-fill-mode)
(setq-default fill-column 80)

(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(setq multi-term-program "/bin/bash")

(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file user-init-file)))
(global-set-key (kbd "C-c o") (lambda () (interactive) (find-file "~/Dropbox/org/log.org")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("392395ee6e6844aec5a76ca4f5c820b97119ddc5290f4e0f58b38c9748181e8d" default)))
 '(package-selected-packages
   (quote
    (magit dap-mode ace-window lsp-ui company-lsp cquery key-chord multi-term flatui-theme merlin tuareg lsp-mode spacemacs-theme racer flymake-rust flycheck-rust evil dracula-theme company cargo atom-one-dark-theme atom-dark-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; OCaml modes
(autoload 'merlin-mode "merlin" "Merlin mode" t)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(add-hook 'tuareg-mode-hook
	  (lambda ()
	    (add-hook 'after-save-hook 'ocamlformat nil 'make-it-local)))
(add-hook 'caml-mode-hook 'merlin-mode)
; Make company aware of merlin
(with-eval-after-load 'company
 (add-to-list 'company-backends 'merlin-company-backend))
; Enable company on merlin managed buffers
(add-hook 'merlin-mode-hook 'company-mode)
; Or enable it globally:
; (add-hook 'after-init-hook 'global-company-mode)

;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
(require 'ocamlformat)


(add-hook 'save-buffer 'ocamlformat-hook)

;; (electric-indent-mode 0) ;; This messes with tuareg for some reason

(delete 'term-mode evil-insert-state-modes)
(add-to-list 'evil-emacs-state-modes 'term-mode)

(require 'lsp-mode)
(add-hook 'c++-mode-hook #'lsp)

(require 'company-lsp)
(push 'company-lsp company-backends)

(require 'cquery)

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)

(require 'clang-format)
(global-set-key (kbd "C-c f") 'lsp-format-buffer)
(setq clang-format-style-option "llvm")

;; TODO turn off electric indent mode in tuareg only
;; TODO turn off evil in eshell
;; TODO organize

(require 'helm-config)

(helm-mode 1)

(add-hook 'lsp-mode-hook
	  (lambda () (local-set-key (kbd "C-c d") 'lsp-find-definition)))

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(require 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)

(require 'dap-mode)
(require 'dap-lldb)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

(global-set-key (kbd "C-x g") 'magit-status)
