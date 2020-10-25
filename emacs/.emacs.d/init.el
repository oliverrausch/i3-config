;;;* Startup Speed Hacks
(setq frame-inhibit-implied-resize t)
(defvar last-file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold 100000000)
(setq compilation-finish-functions (lambda (buf str)
                                     (if (null (string-match ".*exited abnormally.*" str))
                                         ;;no errors, make the compilation window go away in a few seconds
                                         (progn (run-at-time "1 sec" nil 'delete-windows-on
                                                             (get-buffer-create "*compilation*"))
                                                (message "No Compilation Errors!")))))
(setq compilation-scroll-output t)
(setq compilation-window-height 20)
(setq inhibit-compacting-font-caches t)


;;;* Modeline

;; show full buffer path in modeline
(with-eval-after-load 'subr-x
  (setq-default mode-line-buffer-identification
                '(:eval (format-mode-line (propertized-buffer-identification (or (when-let* ((buffer-file-truename buffer-file-truename)
                                                                                             (prj (cdr-safe (project-current)))
                                                                                             (prj-parent (file-name-directory (directory-file-name (expand-file-name prj)))))
                                                                                   (concat (file-relative-name (file-name-directory buffer-file-truename) prj-parent) (file-name-nondirectory buffer-file-truename)))
                                                                                 "%b"))))))
;;;* misc emacs stuff
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")) backup-by-copying t version-control t
      delete-old-versions t kept-new-versions 5 kept-old-versions 5)
(add-to-list 'exec-path "/home/orausch/.local/bin")
(add-to-list 'load-path "~/.emacs.d/elisp")

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Hide startup screen when command line args are passed
(defun my-inhibit-startup-screen-file ()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognised option which
names an existing file."
  (ignore
   (setq inhibit-startup-screen
         (file-exists-p
          (expand-file-name argi command-line-default-directory)))))

(add-hook 'command-line-functions #'my-inhibit-startup-screen-file)

;;;* use-package
(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(require 'use-package-ensure)
(setq use-package-always-ensure t)
;;;* benchmark-init
;;(use-package benchark-init
;;  :config
;;  ;; To disable collection of benchmark data after init is done.
;;  (add-hook 'after-init-hook 'benchmark-init/deactivate))
;;;* ocaml
;; allow jumping back with merlin-locate
(add-hook 'merlin-mode-hook (lambda ()
			      (evil-add-command-properties #'merlin-locate :jump t)))


;;;* evil
(use-package
  evil
  :config (evil-mode))

;; I hate emacs-state, remove it
(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "C-z") nil)
  (define-key evil-motion-state-map (kbd "SPC") nil))

;; suspend-frame is also stupid
(define-key global-map (kbd "C-z") nil)
(define-key global-map (kbd "C-x C-z") nil)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary)

(add-hook 'prog-mode-hook 'evil-commentary-mode)

;; fix <s expansion in org mode
(require 'org-tempo)

(use-package
  evil-org
  :after org
  :config (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook (lambda ()
                                  (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-d") nil)
  (define-key evil-normal-state-map (kbd "C-n") nil)
  (define-key evil-normal-state-map (kbd "C-p") nil)
  (define-key evil-insert-state-map (kbd "C-n") nil)
  (define-key evil-insert-state-map (kbd "C-p") nil))

;;;* theme
(require 'minimal-light-theme)


;;;* simple packages (projectile whichkey lua-mode markdown-mode)
(use-package
  projectile
  :config
  (projectile-mode +1))

(use-package
  which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right))

(use-package
  markdown-mode)

(use-package rg
  :custom
  (ripgrep-arguments
   '("--type-not css" "--type-not html" "-g '!*.sdfg'" "-g '!*.ipynb'" "-g '!TAGS'" "--type-not js")))
(use-package protobuf-mode)

;; (use-package
;;  gruvbox-theme)
;;;* dashboard
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  (setq dashboard-org-agenda-categories '("Tasks" "Appointments"))
  (setq dashboard-startup-banner 'logo)
  (dashboard-setup-startup-hook))

;;;* artist-mode
(defun artist-mode-toggle-emacs-state ()
  (if artist-mode
      (evil-emacs-state)
    (evil-exit-emacs-state)))

                                        ;(add-hook 'artist-mode-hook #'artist-mode-toggle-emacs-
;;;* ivy
(use-package
  ivy
  :config (setq projectile-completion-system 'ivy)
  (ivy-mode 1))

;;;* org

(require 'org-variable-pitch)

;; RICING ORG MODE
(setq org-hide-emphasis-markers t)

;; replace '-' with bullet points
;;(font-lock-add-keywords 'org-mode
;;                        '(("^ *\\([-]\\) "
;;                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-variable-pitch)
(add-hook 'org-mode-hook 'org-variable-pitch-minor-mode)



;; OTHER (MAINLY FUNCTIONAL) STUFF
(require 'org)
(add-hook 'org-capture-mode-hook #'org-align-all-tags)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
(setq org-startup-folded nil)

(add-hook 'org-mode-hook (lambda ()
                           (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))))
(add-hook 'org-mode-hook 'flyspell-mode)
(setq org-return-follows-link t)
;;(add-hook 'org-insert-heading-hook 'evil-insert-state)
(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

(add-to-list 'org-agenda-files "~/org/journal/")

;; fix
;;(defun my-refile ()
;;  (interactive)
;;  (let ((org-refile-targets
;;         (mapcar (lambda (target) (append (list target) '(:maxlevel . 1)))
;;                 (directory-files "~/org/" 'full ".*org"))))
;;    (call-interactively 'org-refile)))

;;(define-key org-mode-map (kbd "C-c C-w") 'my-refile)
;;(define-key org-capture-mode-map (kbd "C-c C-w") 'my-refile)

(defun my-get-image-name ()
  (let ((i 0))
    (while
        (file-exists-p
         (concat
          "/home/orausch/org/img/"
          (file-name-nondirectory (file-name-sans-extension (buffer-file-name)))
          (int-to-string i)
          ".png"))
      (setq i (+ i 1)))
    (concat
     "/home/orausch/org/img/"
     (file-name-nondirectory (file-name-sans-extension (buffer-file-name)))
     (int-to-string i)
     ".png")
    ))


(defun insert-screenshot-at-point ()
  "Make a screenshot, save it in the img folder and insert a link to it."
  (interactive)
  (shell-command-to-string "maim -s /tmp/screen.png")
  (let ((screenshot-name (my-get-image-name)))
    (shell-command-to-string (concat "mv /tmp/screen.png "
                                     screenshot-name))
    (insert (concat "[[" screenshot-name "]]"))))

(defun render-everything ()
  "Render all latex previews and toggle inline images"
  (interactive)
  (org-latex-preview '(16))
  (org-redisplay-inline-images))


(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(setq
 org-adapt-indentation nil
 org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (C . t)
   (ditaa . t)
   (lilypond . t))
 org-capture-templates
 '(("i" "Inbox" entry
    (file "~/org/inbox.org")
    "* TODO")
   ("m" "Meeting Notes- Bachelor's Thesis" entry #'org-journal-find-location "* Meeting %(format-time-string org-journal-time-format) :meeting:dace:
%i%?")
   ("j" "Journal entry" entry #'org-journal-find-location "*  %(format-time-string org-journal-time-format)%^{Title} :%(projectile-project-name):
%i%?")
   ("L" "Protocol Link" entry
    (file+headline "~/org/inbox.org" "Inbox")
    "* TODO %? [[%:link][%:description]]
Captured On: %U"))
 org-clock-out-when-done '("DONE" "WAITING")
 org-export-backends '(ascii html icalendar latex md odt)
 org-fontify-whole-heading-line t)

(use-package adaptive-wrap
  :hook
  (org-mode . adaptive-wrap-prefix-mode))

;;;* lilypond in org
(defun org-babel-lilypond-get-header-args (mode)
  "Default arguments to use when evaluating a lilypond source block.
These depend upon whether we are in Arrange mode i.e. MODE is t."
  (cond (mode
         '((:tangle . "yes")
           (:noweb . "yes")
           (:results . "silent")
           (:cache . "yes")
           (:prologue . "\\paper{indent=0\\mm\nline-width=170\\mm\noddFooterMarkup=##f\noddHeaderMarkup=##f\nbookTitleMarkup=##f\nscoreTitleMarkup=##f}")
           (:comments . "yes")))
        (t
         '((:results . "file")
           (:prologue . "\\paper{indent=0\\mm\nline-width=170\\mm\noddFooterMarkup=##f\noddHeaderMarkup=##f\nbookTitleMarkup=##f\nscoreTitleMarkup=##f}")
           (:exports . "results")))))

;;;* org-roam

(use-package deft
  :after org
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/org"))

(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/org/")
  (org-roam-buffer-no-delete-other-windows t)
  (org-roam-directory "~/org/")
  (org-roam-graph-exclude-matcher '("journal"))
  (org-roam-graph-viewer "~/.local/opt/firefox/firefox")
  :config
  ;; stolen from org-roam-dailies.el
  (setq org-roam-dailies-capture-templates
        '(("d" "daily" plain (function org-roam-capture--get-point)
           ""
           :immediate-finish t
           :file-name "journal/%<%Y-%m-%d>"
           :head "#+TITLE: Journal %<%Y-%m-%d>"))))
(require 'org-roam-protocol)

;; was broken at the time
;;(use-package org-roam-server)

;; not sure if this is required anymore
(setq org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|[0-9]\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")


;;;* cleverparens
(use-package smartparens)
(require 'smartparens-config)
(use-package evil-cleverparens
  :hook
  ((emacs-lisp-mode . evil-cleverparens-mode)
   (evil-cleverparens-mode . smartparens-mode)))

;;;* rainbow-delimiters
(use-package
  rainbow-delimiters
  :hook
  (emacs-lisp-mode-hook . rainbow-delimiters-mode)
  (clojure-mode-hook . rainbow-delimiters-mode)
  (cider-repl-mode-hook . rainbow-delimiters-mode)
  (python-mode-hook . rainbow-delimiters-mode))

;;;* clojure
(use-package clojure-mode
  :hook
  ((clojure-mode . evil-cleverparens-mode)
   (clojurescript-mode . evil-cleverparens-mode)))

(use-package cider
  :config
  (define-key cider-repl-mode-map (kbd "C-n") #'cider-repl-next-input)
  (define-key cider-repl-mode-map (kbd "C-p") #'cider-repl-previous-input))

;;;* Add M-x kill-process (to kill the current buffer's process).
(put 'kill-process 'interactive-form
     '(interactive
       (let ((proc (get-buffer-process (current-buffer))))
         (if (process-live-p proc)
             (unless (yes-or-no-p (format "Kill %S? " proc))
               (error "Process not killed"))
           (error (format "Buffer %s has no process" (buffer-name))))
         nil)))





;;;* magit
(use-package
  magit)

(use-package
  evil-magit
  :after magit)
;;;* c and c++


;;;* company
(use-package
  company
  :defer t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config (use-package
            company-irony
            :defer t)
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1
        company-tooltip-limit 20
        company-dabbrev-downcase nil
        company-backends '((company-irony company-gtags)))
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  :bind ("C-;" . company-complete-common))

(use-package
  company-quickhelp
  :init (add-hook 'company-mode-hook 'company-quickhelp-mode)
  :config (setq company-quickhelp-delay 0.0))


;;;* lsp-mode

(use-package
  lsp-mode
  :init (setq lsp-keymap-prefix "C-l")
  ;; :hook ((python-mode . lsp)
  ;;        (c++-mode-hook . lsp))
  :commands lsp)

(add-hook 'lsp-mode-hook
	  (lambda ()
	    (add-to-list 'lsp-file-watch-ignored "[/\\\\]\\venv$")
            (add-to-list 'lsp-file-watch-ignored "[/\\\\]\\.dacecache$")))

(use-package
  lsp-ivy
  :commands lsp-ivy-workspace-symbol
  :config
  (setq lsp-ivy-show-symbol-kind t)
  (setq lsp-ivy-filter-symbol-kind '(0 2 13))
  (setq lsp-python-ms-python-executable-cmd "/home/orausch/.local/opt/miniconda3/envs/onnx/bin/python"))

(use-package
  lsp-ui
  :commands lsp-ui-mode
  :after lsp-mode
  :init (setq lsp-ui-doc-enable nil)
  :custom
  (lsp-ui-doc-border "black")
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)

  (lsp-ui-doc-position 'top))

(use-package lsp-treemacs
  :commands lsp-treemacs-error-list)


;; (use-package dap-mode
;;   :hook ((python-mode . dap-mode)
;;          (python-mode . dap-ui-mode)
;;          (python-mode . dap-tooltip-mode))
;;   :bind (:map dap-mode-map
;;               (("<f8>" . dap-next)
;;                ("<f9>" . dap-continue))))
;;(use-package dap-python)


;;;* python
(use-package
  yapfify
  :after python)

(use-package python-black
  :after python)

(use-package
  anaconda-mode
  :hook
  ((python-mode . anaconda-mode)
   (python-mode . anaconda-eldoc-mode)))
(use-package
  company-anaconda)

(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))

(use-package
  conda
  :commands conda-env-activate
  :config
  (setq conda-anaconda-home "/opt/anaconda")
  (setq conda-env-home-directory "/home/orausch/.conda")
  (conda-env-initialize-interactive-shells))

(add-hook 'inferior-python-mode-hook
          (lambda ()
            (setq
             indent-tabs-mode nil
             tab-width 4)))


(defun my-send-current-line ()
  (interactive)
  (python-shell-send-string (buffer-substring-no-properties (line-beginning-position) (line-end-position))))

(defun my-maybe-activate ()
  (interactive)
  (unless (and  (boundp 'conda-env-current-name) conda-env-current-name)
    (conda-env-activate)))

;; prompt for conda environment before opening a file
;;(advice-add 'python-mode :before #'my-maybe-activate)

(setq python-shell-interpreter "ipython")
(setenv "PYTHONPATH" "/home/orausch/sources/dace/")

(defun my-python-top-level-def ()
  (interactive)
  (move-beginning-of-line nil)
  (while (not (equal (string (char-after (point)))
                     "d"))
    (python-nav-backward-defun)
    (move-beginning-of-line nil)))

;;(use-package python-pytest
;;  :config
;;  (defun python-pytest--current-defun ()
;;    (save-excursion
;;      (my-python-top-level-def)
;;      (python-info-current-defun))))

(defun my-pytest-file-debug ()
  (interactive)
  (python-pytest-file (buffer-file-name) '("--pdb")))

(defun my-pytest-function-debug ()
  (interactive)
  (python-pytest-function-dwim
   (buffer-file-name)
   (python-pytest--current-defun)
   '("--pdb")))


(setenv "DACE_optimizer_interface" "")

;; (use-package
;;   lsp-python-ms
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-python-ms)
;;                          (lsp))))

(use-package jupyter)

;; no idea why this works
;; see https://emacs.stackexchange.com/questions/44880/use-package-bind-not-working-as-expected
(use-package jupyter-repl
  :ensure nil
  :bind
  (:map jupyter-repl-mode-map
        (("C-p" . jupyter-repl-history-previous)
         ("C-n" . jupyter-repl-history-next))))



;;;* comint mode
;; I think this was to make c-p and c-n work?
(add-hook 'comint-mode-hook (lambda ()
                              (local-set-key [14]
                                             (quote comint-next-input))
                              (local-set-key [16]
                                             (quote comint-previous-input))
                              (local-set-key [18]
                                             (quote comint-history-isearch-backward))))

(add-hook 'shell-mode-hook
      (lambda ()
        (face-remap-set-base 'comint-highlight-prompt :inherit nil)))



;;;* elfeed
(use-package elfeed)
(setq elfeed-feeds
      '(("https://xkcd.com/atom.xml" comic)
        ("https://drewdevault.com/feed.xml" blog)
        ("https://danluu.com/atom.xml" blog)
        ("http://fabiensanglard.net/rss.xml" blog)
        ("https://lwn.net/headlines/rss" blog)
        ("http://www.regressionist.com/rss" blog)))
;;;* Customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(add-hook 'after-init-hook t)
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(clang-format-style "google")
 '(column-number-mode t)
 '(compilation-message-face 'default)
 '(custom-enabled-themes '(leuven))
 '(custom-safe-themes
   '("ad4dad5819db4ba67e85b249b281b649dfd3e37ab38b30d778bb4f3f031ed47e" default))
 '(fci-rule-color "#37474F" t)
 '(fill-column 100)
 '(indent-tabs-mode nil)
 '(lua-indent-level 4)
 '(package-selected-packages
   '(company-anaconda anaconda-mode lsp-pyright yapfify which-key use-package rg rainbow-delimiters python-pytest python-black protobuf-mode org-roam-server magit-popup lua-mode lsp-ui lsp-ivy jupyter general evil-surround evil-org evil-magit evil-commentary evil-cleverparens elfeed deft dashboard dap-mode conda company-quickhelp company-lsp company-irony cider adaptive-wrap))
 '(safe-local-variable-values '((eval outline-hide-sublevels 4)))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(vc-annotate-background-mode nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Fixed" :foundry "BE5N" :slant normal :weight normal :height 128 :width normal))))
 '(jupyter-repl-input-prompt ((t (:foreground "dark green"))))
 '(jupyter-repl-output-prompt ((t (:foreground "red4"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green4"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "dark violet"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "saddle brown")))))


;;;* keymaps
(defconst my-leader "SPC")

(use-package general
  :config)

(general-create-definer my-leader-def
  :prefix my-leader)

(my-leader-def
  :states '(normal emacs motion)

  ;; projectile
  "p" '(:ignore t :which-key "projects")
  "p f" '(projectile-find-file :which-key "find file")
  "p s" '(projectile-save-project-buffers :which-key "save buffers")
  "p k" '(projectile-kill-buffers :which-key "kill buffers")
  "p p" '(projectile-switch-project :which-key "open project")

  "r" '(rg-menu :which-key "ripgrep")

  ;; highlighting
  "h" '(:ignore t :which-key "highlighting")
  "h s" '(highlight-symbol-at-point :which-key "highlight symbol")
  "h h" '((lambda () (interactive) (unhighlight-regexp t)) :which-key "unhighlight all")

  ;; files
  "f" '(:ignore t :which-key "files")
  "f f" 'find-file
  "f i" `(,(lambda ()
             (interactive)
             (find-file "~/sources/config/emacs/.emacs.d/init.el")) :which-key "init.el")
  "f t" 'org-roam-dailies-today

  ;; org stuff
  "a" 'org-agenda
  "c" 'org-capture

  ;; show error at point
  "e" 'display-local-help

  "q" '(quit-window :which-key"quit window")

  "p" '(:ignore t :which-key "org links")
  "p s" 'org-store-link
  "p i" 'org-insert-link

  ;; help functions
  "d" '(:ignore t :which-key "describe")
  "d v" 'describe-variable
  "d f" 'describe-function

  ;; roam
  "n" '(:ignore t :which-key "roam")
  "n l" '(org-roam :which-key "sidebar")
  "n f" '(org-roam-find-file :which-key "find file")
  "n s" '(org-roam-server-mode :which-key "start server")
  "n d" '(deft :which-key "deft (search)")

  ;; others
  "g" 'magit-status
  "b" '(neotree-project-dir :which-key "files sidebar"))

(my-leader-def
  :keymaps 'emacs-lisp-mode-map
  :states 'normal
  ;; for use in init.el
  "o" 'org-cycle)

(my-leader-def
  :keymaps 'tuareg-mode-map
  :states 'normal

  "l" '(:ignore t :which-key "ocaml")
  "l l" '(merlin-locate :which-key "definition")
  "l t" '(merlin-type-enclosing :which-key "type")
  "l d" '(merlin-document :which-key "document")

  "i" '(:ignore t :which-key "interactive")
  "i b" '(tuareg-eval-buffer :which-key "send buffer")
  "i RET" '(tuareg-eval-phrase :which-key "send phrase"))

(my-leader-def
  :keymaps 'lsp-mode-map
  :states 'normal

  "l" '(:ignore t :which-key "lsp")
  "l l" '(lsp-find-definition :which-key "definition")
  "l g" '(lsp-peek-find-references :which-key "references")
  "l r" '(lsp-rename :which-key "rename")
  "l s" '(lsp-ivy-workspace-symbol :which-key "find symbol"))

(my-leader-def
  :keymaps 'org-mode-map
  :states 'normal
  "s" 'insert-screenshot-at-point
  "y" 'render-everything
  "n i" '(org-roam-insert :which-key "insert link"))

(my-leader-def
  :keymaps 'smerge-mode-map
  :states 'normal
  "s" 'smerge-keep-current)

(my-leader-def
  :keymaps 'dap-mode-map
  :states 'normal

  "d" '(:ignore t :which-key "debug")
  "d d" '(dap-debug :which-key "debug")
  "d n" '(dap-next :which-key "next (<f5>)")
  "d c" 'dap-continue
  "d i" '(dap-step-in :which-key "in (<f6>)")
  "d b" 'dap-breakpoint-toggle
  "d r" 'dap-ui-repl
  "d e" 'dap-eval
  "d s" 'dap-switch-stack-frame)

(my-leader-def
  :keymaps 'python-mode-map
  :states 'normal

  "k" '(:ignore t :which-key "format code")
  "k y" '(yapfify-region-or-buffer :which-key "yapf")

  "i" '(:ignore t :which-key "interactive")
  "i i" '(jupyter-inspect-at-point :which-key "jupyter inspect at point")
  "i j" '(jupyter-run-repl :which-key "start jupyter repl")
  "i b" '(jupyter-eval-buffer :which-key "send buffer")
  "i s" '(jupyter-repl-scratch-buffer :which-key "open scratch buffer")
  "i RET" '(jupyter-eval-line-or-region :which-key "send region or line (C-c C-c)")
  "i k" '(jupyter-repl-interrupt-kernel :which-key "interrupt kernel")
  "i r" '(jupyter-repl-restart-kernel :which-key "restart kernel")

  "t" '(:ignore t :which-key "tests")
  "t b" '(python-pytest-file :which-key "buffer")
  "t f" '(python-pytest-function-dwim :which-key "function")
  "t r" '(python-pytest-repeat :which-key "repeat")
  "t B" '(my-pytest-file-debug :which-key "debug buffer")
  "t F" '(my-pytest-function-debug :which-key "debug function"))



(evil-set-initial-state 'elfeed-search-mode 'emacs)
(evil-set-initial-state 'elfeed-show-mode 'emacs)

(general-define-key
 :states '(emacs normal)
 :keymaps 'elfeed-show-mode-map
 "h" 'left-char
 "l" 'right-char
 "j" 'next-line
 "k" 'previous-line
 "q" 'quit-window)

(general-define-key
 :states '(emacs normal)
 :keymaps 'elfeed-search-mode-map
 "j" 'next-line
 "k" 'previous-line)

;; Make evil-mode up/down operate in screen lines instead of logical lines
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
;; Also in visual mode
(define-key evil-visual-state-map "j" 'evil-next-visual-line)
(define-key evil-visual-state-map "k" 'evil-previous-visual-line)

;;;* Disable Speed hacks
(add-hook 'emacs-startup-hook (lambda ()
                                (setq gc-cons-threshold 16777216 gc-cons-percentage 0.1
                                      file-name-handler-alist last-file-name-handler-alist)))
(server-start)
;;;* make outline mode work
;; Local Variables:
;; outline-regexp: ";;;\\*+\\|\\`"
;; eval: (outline-minor-mode 1)
;; eval: (outline-hide-sublevels 4)
;; End:
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
