;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(server-start)
(package-initialize)
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "www-proxy-ams.nl.oracle.com:80")
        ("https" . "www-proxy-ams.nl.oracle.com:80")))

(use-package evil
  :ensure t
  :config
  (evil-mode))

(use-package org
  :init
  (defun my-org-agenda-skip-all-siblings-but-three ()
    "Skip all but the three non-done entries."
    (let (should-skip-entry)
      (unless (org-current-is-todo)
	(setq should-skip-entry t))
      (save-excursion
	(while (and (not should-skip-entry) (org-goto-sibling t))
	  (when (org-current-is-todo)
	    (setq should-skip-entry t))))
      (when should-skip-entry
	(or (outline-next-heading)
	    (goto-char (point-max))))))
  (defun org-current-is-todo ()
    (string= "TODO" (org-get-todo-state)))
  :config
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (setq org-agenda-custom-commands 
	'(("o" "At the office" tags-todo "@office"
	   ((org-agenda-overriding-header "Office")
	    (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))
  (require 'org-protocol)
  (add-hook 'org-clock-goto-hook 'org-narrow-to-subtree)
  (add-hook 'org-insert-heading-hook 'evil-insert-state)
  (global-set-key (kbd "<f12>") 'org-clock-goto)
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))))


(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	    (lambda ()
	      (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


(use-package company
  :ensure t
  :config
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))
 
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode))

(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "<f11>") 'magit-status))

(use-package evil-magit
  :ensure t)

(use-package ivy
  :ensure t
  :config
  (ivy-mode))


;; Opening Files
(global-set-key (kbd "<f2>") (lambda() (interactive) (find-file "~/org/tasks.org")))
(global-set-key (kbd "<f3>") (lambda() (interactive) (find-file "~/org/inbox.org")))

(auto-fill-mode 1)
(setq fill-column 120)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (leuven)))
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-eldoc elpy-module-flymake elpy-module-pyvenv elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults)))
 '(elpy-rpc-python-command "/home/orausch/.local/opt/miniconda3/bin/python3")
 '(fill-column 100)
 '(lua-indent-level 4)
 '(menu-bar-mode nil)
 '(org-adapt-indentation nil)
 '(org-agenda-files (quote ("~/org/tasks.org")))
 '(org-capture-templates
   (quote
    (("i" "Inbox" entry
      (file "~/org/inbox.org")
      "* TODO")
     ("l" "Link entry" entry
      (file "~/org/inbox.org")
      "* %a"))))
 '(org-clock-out-when-done (quote ("DONE" "WAITING")))
 '(org-refile-targets (quote (("~/org/tasks.org" :maxlevel . 1))))
 '(package-selected-packages
   (quote
    (evil-org use-package evil-commentary lua-mode rainbow-delimiters markdown-mode elpy evil-magit magit all-the-icons-ivy counsel yasnippet-snippets org htmlize find-file-in-project evil)))
 '(python-shell-interpreter "/home/orausch/.local/opt/miniconda3/bin/python")
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-2-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green4"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "dark violet"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "saddle brown")))))

(add-hook 'elpy-mode-hook
	  (lambda ()
	    (local-set-key [f4] (quote elpy-goto-definition))))

(add-hook 'comint-mode-hook
	  (lambda ()
	   (local-set-key [14] (quote comint-next-input))
	   (local-set-key [16] (quote comint-previous-input))
	   (local-set-key [18] (quote comint-history-isearch-backward))))
