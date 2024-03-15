(defvar elpaca-installer-version 0.6)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
			:ref nil
			:files (:defaults (:exclude "extensions"))
			:build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
 (build (expand-file-name "elpaca/" elpaca-builds-directory))
 (order (cdr elpaca-order))
 (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
  (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
	   ((zerop (call-process "git" nil buffer t "clone"
				 (plist-get order :repo) repo)))
	   ((zerop (call-process "git" nil buffer t "checkout"
				 (or (plist-get order :ref) "--"))))
	   (emacs (concat invocation-directory invocation-name))
	   ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
				 "--eval" "(byte-recompile-directory \".\" 0 'force)")))
	   ((require 'elpaca))
	   ((elpaca-generate-autoloads "elpaca" repo)))
      (kill-buffer buffer)
    (error "%s" (with-current-buffer buffer (buffer-string))))
((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

;;When installing a package which modifies a form used at the top-level
;;(e.g. a package which adds a use-package key word),
;;use `elpaca-wait' to block until that package has been installed/configured.
;;For example:
;;(use-package general :demand t)
;;(elpaca-wait)

;;Turns off elpaca-use-package-mode current declartion
;;Note this will cause the declaration to be interpreted immediately (not deferred).
;;Useful for configuring built-in emacs features.
;;(use-package emacs :elpaca nil :config (setq ring-bell-function #'ignore))

;; Don't install anything. Defer execution of BODY
;;(elpaca nil (message "deferred"))

;; Expands to: (elpaca evil (use-package evil :demand t))
(use-package evil
    :bind (:map evil-normal-state-map
                ("<C-u>" . evil-scroll-page-up))
    :init      ;; tweak evil's configuration before loading it
    (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
    (setq evil-respect-visual-line-mode t)
    (setq evil-want-keybinding nil)
    (setq evil-vsplit-window-right t)
    (setq evil-split-window-below t)
    (evil-mode))
  (use-package evil-collection
    :after evil
    :config
    (setq evil-collection-mode-list '(dashboard dired ibuffer))
    (evil-collection-init))

(use-package general
    :config
    (general-evil-setup)
    ;; set 'SPC' as global leader key
    (general-create-definer lm/leader-keys
      :states '(normal insert visual emacs)
      :keymaps 'override
      :prefix "SPC" ;; set leader
      :global-prefix "M-SPC") ;; access leader in insert mode

    (lm/leader-keys
        "b" '(:ignore t :wk "buffer")
        "b b" '(switch-to-buffer :wk "Switch buffer")
        "b i" '(ibuffer :wk "Ibuffer")
        "b k" '(kill-this-buffer :wk "Kill this buffer")
        "b n" '(next-buffer :wk "Next buffer")
        "b p" '(previous-buffer :wk "Previous buffer")
        "b r" '(revert-buffer :wk "Reload buffer"))

    (lm/leader-keys
        "e" '(:ignore t :wk "Eshell/Evaluate")
        "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
        "e d" '(eval-defun :wk "Evaluate defun containing or after point")
        "e e" '(eval-expression :wk "Evaluate an elisp expression")
        "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
        "e r" '(eval-region :wk "Evaluate elisp in region")
        "e h" '(counsel-esh-history :wk "Eshell history")
        "e s" '(eshell :wk "Eshell"))

    (lm/leader-keys
        "SPC" '(counsel-M-x :wk "Counsel M-x")
        "." '(find-file :wk "Find file")
        "f c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
        "f r" '(counsel-recentf :wk "Find recent files")
        "TAB TAB" '(comment-line :wk "Comment lines"))

    (lm/leader-keys
        "h" '(:ignore t :wk "Help")
        "h f" '(describe-function :wk "Describe function")
        "h v" '(describe-variable :wk "Describe variable")
        "h r r" '(reload-init-file :wk "Reload emacs config"))
        ;; "h r r" '((lambda () (interactive) (load-file user-init-file)) :wk "Reload emacs config"))

    (lm/leader-keys
        "i" '(:ignore t :wk "Insert")
        "i p" '(org-download-screenshot :wk "Insert screenshot (org)"))

    (lm/leader-keys
        "t" '(:ignore t :wk "Toggle")
        "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
        "t v" '(vterm-toggle :wk "Toggle Vterm")
        "t i" '(org-toggle-inline-images :wk "Toggle inline images")
        "t t" '(visual-line-mode :wk "Toggle truncated lines"))

    (lm/leader-keys
        "s" '(:ignore t :wk "Shell")
        "s c" '(shell-command :wk "Run a shell command")
        "s d" '(sh-cd-here :wk "Move current shell to current dir")
        "s m" '(sh-mode :wk "Shell mode"))

    (lm/leader-keys
        "c" '(:ignore t :wk "Capitalize")
        "c w" '(capitalize-word :wk "Capitalize word")
        "c r" '(capitalize-region :wk "Capitalize region")
        "c c" '(upcase-char :wk "Upcase char")
        "c u" '(upcase-region :wk "Upcase region"))

    (lm/leader-keys
        "l" '(:ignore t :wk "Downcase")
        "l w" '(downcase-word :wk "Downcase word")
        "l u" '(downcase-region :wk "Downcase region"))

    ;; Evil window bindings
    (lm/leader-keys
        "w" '(:ignore t :wk "Window")
        "w w" '(evil-window-next :wk "Next window")
        "w h" '(evil-window-left :wk "Move cursor to window left")
        "w j" '(evil-window-down :wk "Move cursor to window below")
        "w k" '(evil-window-up :wk "Move cursor to window above")
        "w l" '(evil-window-right :wk "Move cursor to window right")
        "w s" '(evil-window-split :wk "Split window horizontally")
        "w v" '(evil-window-vsplit :wk "Split window vertically")
        "w H" '(evil-window-move-far-left :wk "Move split to left")
        "w J" '(evil-window-move-very-bottom :wk "Move split to bottom")
        "w K" '(evil-window-move-very-top :wk "Move split to top")
        "w L" '(evil-window-move-far-right :wk "Move split to right")
        "w c" '(evil-window-delete :wk "Close window")
        "w o" '(delete-other-windows :wk "__")
        "w =" '(balance-windows :wk "__")
        "q k" '(kill-buffer-and-window :wk "Kill buf and window")
        "q q" '(save-buffers-kill-terminal :wk "Save bufs, kill term"))

    ;; (evil-global-set-key 'visual "K" (kbd ":m '<-2 RET gv '< gk")) 
    (evil-global-set-key 'visual "K" 'drag-stuff-up) 
    ;; (evil-global-set-key 'visual "J" (kbd ":m '>+1 RET gv '> gj")) 
    (evil-global-set-key 'visual "J" 'drag-stuff-down)

    (lm/leader-keys
       "p" '(:ignore t :wk "Project")
       "p o" '(dashboard-open :wk "Return to dashboard")
       "p f" '(project-find-file :wk "Find project file"))

)

(use-package all-the-icons
    :ensure t
    :diminish
    :if (display-graphic-p))
(use-package all-the-icons-dired
    :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(setq backup-directory-alist
      `((".*" . "~/emacs/auto-saves")))
(setq auto-save-file-name-transforms
      `((".*" "~/emacs/auto-saves" t)))

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(use-package dashboard
      :ensure t
      :diminish
      :init
      (setq initial-buffer-choice 'dashboard-open)
      (setq dashboard-set-heading-icons t)
      ;; (setq dashboard-set-navigator t)
      (setq dashboard-set-file-icons t)
      (setq dashboard-banner-logo-title "Welcome to Emacs!")
      ;; (setq dashboard-startup-banner 'logo) ;; default logo
      (setq dashboard-startup-banner "~/pictures/smol-penguin.png")
      (setq dashboard-center-content t)
      (setq dashboard-items '((recents . 5)
                              (agenda . 5)
                              (bookmarks . 3)
                              ;; (registers . 3)
                              (projects . 3)))
;; (dashboard-modify-heading-icons '((recents . "file-text")
                                  ;; (bookmarks . "book")))  
      :config
      (dashboard-setup-startup-hook))

(use-package diminish)

(use-package drag-stuff
    :diminish
    :config
(drag-stuff-global-mode 1))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

(set-face-attribute 'default nil
;; try switch to Source Code Pro
    :font "FiraCodeNerdFontMono"
    :height 110
    :weight 'medium)
  (set-face-attribute 'variable-pitch nil
    :font "FiraCodeNerdFontMono"
    :height 120
    :weight 'medium)
  (set-face-attribute 'fixed-pitch nil
    :font "FiraCodeNerdFontMono"
    :height 110
    :weight 'medium)
  ;; Makes commented text and keywords italics.
  ;; This is working in emacsclient but not emacs.
  ;; Your font must have an italic face available.
  (set-face-attribute 'font-lock-comment-face nil
    :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil
    :slant 'italic)

  ;; This sets the default font on all graphical frames created after restarting Emacs.
  ;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
  ;; are not right unless I also add this method of setting the default font.
  (add-to-list 'default-frame-alist '(font . "FiraCodeNerdFontMono-14"))

  ;; Uncomment the following line if line spacing needs adjusting.
  ;; (setq-default line-spacing 0.12)

(global-set-key (kbd "C-=") 'text-scale-increase) 
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package gnuplot-mode)
;; automatically open files ending with .gp or .gnuplot in gnuplot mode
;; (setq auto-mode-alist 
;; (append '(("\\.\\(gp\\|gnuplot\\)$" . gnuplot-mode)) auto-mode-alist)))

(use-package image-dired+)

(setq-default indent-tabs-mode nil)
 (setq-default tab-width 4)
 (setq-default indent-line-function 'insert-tab)
 (setq-default c-default-style "linux"
               c-basic-offset 4)
;; if indent-tabs-mode is off, untabify before saving
;;(add-hook 'write-file-hooks 
;;         (lambda () (if (not indent-tabs-mode)
;;                        (untabify (point-min) (point-max)))))

;; This assumes you've installed the package via MELPA.
(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all FiraMonoNerdFont and Fira Code ligatures in programming modes

  (ligature-set-ligatures 'prog-mode
                      '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                        ;; =:= =!=
                        ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                        ;; ;; ;;;
                        (";" (rx (+ ";")))
                        ;; && &&&
                        ("&" (rx (+ "&")))
                        ;; !! !!! !. !: !!. != !== !~
                        ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                        ;; ?? ??? ?:  ?=  ?.
                        ("?" (rx (or ":" "=" "\." (+ "?"))))
                        ;; %% %%%
                        ("%" (rx (+ "%")))
                        ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                        ;; |->>-||-<<-| |- |== ||=||
                        ;; |==>>==<<==<=>==//==/=!==:===>
                        ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                        "-" "=" ))))
                        ;; \\ \\\ \/
                        ("\\" (rx (or "/" (+ "\\"))))
                        ;; ++ +++ ++++ +>
                        ("+" (rx (or ">" (+ "+"))))
                        ;; :: ::: :::: :> :< := :// ::=
                        (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                        ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                        ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                        "="))))
                        ;; .. ... .... .= .- .? ..= ..<
                        ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                        ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                        ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                        ;; *> */ *)  ** *** ****
                        ("*" (rx (or ">" "/" ")" (+ "*"))))
                        ;; www wwww
                        ("w" (rx (+ "w")))
                        ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                        ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                        ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                        ;; << <<< <<<<
                        ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                        "-"  "/" "|" "="))))
                        ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                        ;; >> >>> >>>>
                        (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                        ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                        ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                     (+ "#"))))
                        ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                        ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                        ;; __ ___ ____ _|_ __|____|_
                        ("_" (rx (+ (or "_" "|"))))
                        ;; Fira code: 0xFF 0x12
                        ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                        ;; Fira code:
                        "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                        ;; The few not covered by the regexps.
                        "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))

  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; inspired by https://zzamboni.org/post/how-to-insert-screenshots-in-org-documents-on-macos/

(use-package org-download
  :after org
  :defer nil
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "~/emacs/")
  (org-download-heading-lvl 0)
  (org-download-timestamp "org_%Y%m%d-%H%M%S_")
  ;; (org-image-actual-width 400)
  (org-download-screenshot-method "wl-paste -t image/png > '%s'")
  :bind
  ("C-M-y" . org-download-screenshot)
  :config
  (require 'org-download))

(use-package projectile
  :diminish
  :config
  (projectile-mode 1))

(use-package rainbow-mode
  :diminish
  :hook 
  ((org-mode prog-mode) . rainbow-mode))

(defun reload-init-file ()
  (interactive)
  (load-file user-init-file)
  (load-file user-init-file))

(use-package eshell-syntax-highlighting
    :after esh-mode
    :config
    (eshell-syntax-highlighting-global-mode +1))

    (setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
      eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))

(use-package vterm
:config
(setq shell-file-name "/bin/bash"
      vterm-max-scrollback 5000))

(use-package vterm-toggle
    :after vterm
    :config
    (setq vterm-toggle-fullscreen-p nil)
    (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
             '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                (display-buffer-reuse-window display-buffer-at-bottom)
                ;;(display-buffer-reuse-window display-buffer-in-direction)
                ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                ;;(direction . bottom)
                ;;(dedicated . t) ;dedicated is supported in emacs27
                (reusable-frames . visible)
                (window-height . 0.3))))

(use-package sudo-edit
    :config
      (lm/leader-keys
          "fu" '(sudo-edit-find-file :wk "Sudo find file")
          "fU" '(sudo-edit :wk "Sudo edit file")))

;;(add-to-list 'custom-theme-load-path "~/.config/emacs/themes")
;;(load-theme 'soft-charcoal t)

(use-package doom-themes
:ensure t
:config
;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
  doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-monokai-spectrum t)
  ;; (load-theme 'doom-monokai-machine t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
(doom-themes-treemacs-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config))

(add-to-list 'default-frame-alist '(alpha-background . 90)) ;; for all new frames

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 0)
(menu-bar--display-line-numbers-mode-relative)
;; (setq display-line-numbers-mode-relative 't)

(global-visual-line-mode t)

(use-package counsel
  :after ivy
  :diminish
  :config (counsel-mode))

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))

(use-package all-the-icons-ivy-rich
  :ensure t
  :diminish
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :diminish
  :ensure t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package zig-mode)
;; (use-package jai-mode)
(use-package rust-mode)
(use-package cargo-mode)
(use-package lua-mode)
(add-to-list 'load-path "~/.config/emacs/manual-packages")
(require 'odin-mode)

(use-package toc-org
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
;;(setq (setq org-return-follows-link  t)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(require 'org-tempo)

(use-package which-key
  :init
      (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-ide-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit nil
        which-key-separator " -> " ))
