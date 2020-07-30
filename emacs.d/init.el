(require 'package)

;; TODO
;; I don't know having this here will put multiple .emacs.d in my load path
;; Also maybe I should make it not hard coded to this path
(setq load-path (cons "~/.emacs.d/lisp" load-path))


(load "ssl-warning")

(package-initialize)

; (require 'which-key)
(which-key-mode)

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file user-init-file)))
(setq lsp-keymap-prefix "C-l")

(use-package lsp-mode
  :hook
  ((c++-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)
;; TODO company-lsp

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
  
(use-package ccls
  :hook
  ((c++-mode) . (lambda ()
		  (require 'ccls)
		  (lsp))))

(use-package org
  :custom
  (org-directory "~/Dropbox/org")
  (org-agenda-files '("~/Dropbox/org/inbox.org"))
  (org-log-done 'time)
  (org-capture-templates '(("i" "Inbox" entry (file "inbox.org") ""))))

;; TODO do not hard code directory
;; TODO may need to make directory first?
(use-package org-roam
  :custom
  (org-roam-directory "~/Dropbox/org/roam")
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
  (org-journal-dir org-roam-directory) ; TODO will `org-roam-directory be initialized?
  (org-journal-date-format "%A, %d %B %Y"))

(add-hook 'text-mode-hook 'auto-fill-mode)
(setq-default fill-column 80)

;; (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (key-chord lsp-treemacs ccls lsp-ui flycheck lsp-mode which-key magit org-journal use-package org-roam evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
