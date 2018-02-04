(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;'(custom-enabled-themes (quote (wombat)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Bra indrag.
;;(setq c-default-style "stroustrup")
;; Vissa föredrar denna ...
(setq c-default-style "ellemtel")

;; Bra tangentbindningar: F4 tar bort/fram menylisten:
(global-set-key [f4] 'menu-bar-mode)
;  F5 ändrar "line-wrap".
(global-set-key [f5] 'toggle-truncate-lines)
;; Emacs21-specifikt.
;; Tar bort "skräp".
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
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(global-linum-mode 1)
(global-set-key (kbd "C-z") 'undo)


; start package.el with emacs
(require 'package)

; add MELPA to repository list
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
; initialize package.el
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; (defvar myPackages
;;   '(better-defaults
;;     material-theme
;;     auto-complete
;;     yasnippet
;;     iedit
;;     rainbow-delimiters))

;; (mapc #'(lambda (package)
;;     (unless (package-installed-p package)
;;       (package-install package)))
;;       myPackages)

; start these packages with emacs
(require 'auto-complete)
; do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)
(require 'yasnippet)
(yas-global-mode 1)
(require 'iedit)
(require 'rainbow-delimiters)
(require 'better-defaults)
(require 'rainbow-mode)


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
