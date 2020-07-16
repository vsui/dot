(require 'package)

;; TODO
;; I don't know having this here will put multiple .emacs.d in my load path
;; Also maybe I should make it not hard coded to this path
(setq load-path (cons "~/.emacs.d/lisp" load-path))

(load "ssl-warning")

(package-initialize)

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; TODO do not hard code directory
;; TODO may need to make directory first?
(use-package org-roam
  :custom
  (org-roam-directory "~/Sync/org/roam")
  (org-roam-buffer-position 'top)
  :bind
  (:map org-roam-mode-map
	(("C-c n l" . org-roam)
	 ("C-C n f" . org-roam-find-file)
	 ("C-c n g" . org-roam-graph))
   :map org-mode-map
	(("C-c n i" . org-roam-insert))
	(("C-c n I" . org-roam-insert-immediate))))
(add-hook 'after-init-hook 'org-roam-mode)

;; Set up org-journal to work with org-roam
(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-date-prefix "#+title: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Sync/org/roam")
  (org-journal-date-format "%A, %d %B %Y"))

(add-hook 'text-mode-hook 'auto-fill-mode)
(setq-default fill-column 110)

(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file user-init-file)))

;; (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
;; 
;; 
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;    (quote
;;     ("392395ee6e6844aec5a76ca4f5c820b97119ddc5290f4e0f58b38c9748181e8d" default)))
;;  '(package-selected-packages
;;    (quote
;;     (cmake-mode helm-rg helm-projectile ripgrep projectile magit dap-mode ace-window lsp-ui company-lsp cquery key-chord multi-term flatui-theme merlin tuareg lsp-mode spacemacs-theme racer flymake-rust flycheck-rust evil dracula-theme company cargo atom-one-dark-theme atom-dark-theme))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;; 
;; ;; OCaml modes
;; (autoload 'merlin-mode "merlin" "Merlin mode" t)
;; (add-hook 'tuareg-mode-hook 'merlin-mode)
;; (add-hook 'tuareg-mode-hook
;; 	  (lambda ()
;; 	    (add-hook 'after-save-hook 'ocamlformat nil 'make-it-local)))
;; (add-hook 'caml-mode-hook 'merlin-mode)
;; ; Make company aware of merlin
;; (with-eval-after-load 'company
;;  (add-to-list 'company-backends 'merlin-company-backend))
;; ; Enable company on merlin managed buffers
;; (add-hook 'merlin-mode-hook 'company-mode)
;; ; Or enable it globally:
;; ; (add-hook 'after-init-hook 'global-company-mode)
;; 
;; (require 'ocamlformat)
;; 
;; (add-hook 'save-buffer 'ocamlformat-hook)
;; 
;; ;; (electric-indent-mode 0) ;; This messes with tuareg for some reason
;; 
;; (delete 'term-mode evil-insert-state-modes)
;; (add-to-list 'evil-emacs-state-modes 'term-mode)
;; 
;; (require 'lsp-mode)
;; (add-hook 'c++-mode-hook #'lsp)
;; 
;; (require 'company-lsp)
;; (push 'company-lsp company-backends)
;; 
;; (require 'cquery)
;; 
;; (require 'lsp-ui)
;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
;; (add-hook 'c++-mode-hook 'flycheck-mode)
;; 
;; (global-set-key (kbd "C-c f") 'lsp-format-buffer)
;; 
;; (defun lsp-mode-before-save-hook ()
;;   (when (eq major-mode 'c++-mode)
;;     (lsp-format-buffer)))
;; 
;; (add-hook 'before-save-hook #'lsp-mode-before-save-hook)
;; 
;; 
;; ;; TODO turn off electric indent mode in tuareg only
;; ;; TODO turn off evil in eshell
;; ;; TODO organize
;; 
;; (require 'helm-config)
;; 
;; (helm-mode 1)
;; 
;; (add-hook 'lsp-mode-hook
;; 	  (lambda () (local-set-key (kbd "C-c d") 'lsp-find-definition)))
;; 
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; 
;; (require 'ace-window)
;; (global-set-key (kbd "M-o") 'ace-window)
;; 
;; (require 'dap-mode)
;; (require 'dap-lldb)
;; 
;; (setq backup-directory-alist `(("." . "~/.saves")))
;; (setq backup-by-copying t)
;; 
;; (global-set-key (kbd "C-x g") 'magit-status)
;; 
;; (add-to-list 'package-pinned-packages '(projectile . "melpa-stable") t)
;; (require 'projectile)
;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; (projectile-mode 1)
;; 
;; (add-to-list 'projectile-globally-ignored-directories "build")
;; 
;; (require 'helm-projectile)
;; (helm-projectile-on)
;; 
;; (setq projectile-git-submodule-command nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Sync/org/inbox.org")))
 '(org-capture-templates
   (quote
    (("" "" entry
      (file "~/Sync/org/inbox.org")
      "")
     ("i" "Inbox" entry
      (file "~/Sync/org/inbox.org")
      ""))))
 '(package-selected-packages (quote (magit org-journal use-package org-roam evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
