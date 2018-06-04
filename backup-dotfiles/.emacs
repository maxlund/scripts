(setq c-default-style "ellemtel")

; toggle menu
(global-set-key [f4] 'menu-bar-mode)
;  F5 change "line-wrap".
(global-set-key [f5] 'toggle-truncate-lines)
;; Emacs21-specifikt.
;; remove junk
(if (string-match "^21" emacs-version)
        (progn
          (tool-bar-mode -1)
          (blink-cursor-mode -1)))

;; Framhäv markerat område genom invertering.
(transient-mark-mode t)

;; Markera matchande parenteser.
(show-paren-mode 1)
;; Diverse bra saker
(setq next-line-add-newlines nil)   ; Lägg inte till nya rader efter EOF.
(setq line-number-mode t)           ; Visa radnummer...
(setq column-number-mode t)         ; ...och kolumn.
(setq-default indent-tabs-mode nil) ; Använd alltid mellanrumstecken, ej tab, för indrag. 
(setq c-basic-offset 3)             ; Indragssdjup.
(setq display-time-day-and-date t)  ; Visa tid och datum...
(setq display-time-24hr-format t)   ; ...så att man fattar.
(display-time)                      ; Visa tiden formaterad enligt ovan.
(setq neo-theme 'icons)             ; set icons to filetree
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(global-linum-mode 1)
(setq inhibit-startup-screen t)


(global-set-key (kbd "C-z") 'undo)  ; rebind undo
(global-set-key (kbd "C-q") 'clipboard-yank)  ; rebind paste

; function to copy whole line if no region is marked
(defun my-kill-ring-save (beg end flash)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end) nil)
                 (list (line-beginning-position)
                       (line-beginning-position 2) 'flash)))
  (kill-ring-save beg end)
  (when flash
    (save-excursion
      (if (equal (current-column) 0)
          (goto-char end)
        (goto-char beg))
      (sit-for blink-matching-delay))))
; bind to default copy keybind
(global-set-key [remap kill-ring-save] 'my-kill-ring-save)

; function to cut whole line if no region is marked
(defun my-kill-ring-cut (beg end flash)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end) nil)
                 (list (line-beginning-position)
                       (line-beginning-position 2) 'flash)))
  (kill-region beg end)
  (when flash
    (save-excursion
      (if (equal (current-column) 0)
          (goto-char end)
        (goto-char beg))
      (sit-for blink-matching-delay))))
; bind to default cut keybind
(global-set-key [remap kill-region] 'my-kill-ring-cut)

; start package.el with emacs
(require 'package)

; add MELPA to repository list
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
; add marmalade to repo list
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
; initialize package.el
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    material-theme
    auto-complete
    yasnippet
    iedit
    rainbow-delimiters
    neotree
    all-the-icons))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

; start these packages with emacs
(require 'auto-complete)
; do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)
;; (require 'yasnippet)
;; (yas-global-mode 1)
(require 'iedit)
(require 'rainbow-delimiters)
(require 'better-defaults)
(require 'rainbow-mode)
(require 'neotree)
(require 'all-the-icons)
(require 'material-theme)
;; remember to install the fonts for icons:
;; M-x all-the-icons-install-fonts

; a function which initializes auto-complete-c-headers and gets called for c/c++ hooks
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/lib/gcc/x86_64-linux-gnu/5/include")
  )

; call this function from c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++17")))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++17")))
;(add-hook 'c++-mode-hook (lambda ()(c-toggle-auto-newline 1)))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(load-theme 'material t)
(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(provide '.emacs)
;;; .emacs ends here
