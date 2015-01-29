;;; Emacs is not a package manager, and here we load its package manager!
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)

;; color theme 
(require 'color-theme)  
(color-theme-initialize)  
(color-theme-matrix)  
(color-theme-subtle-blue)

;; system font
(when (member "DejaVu Sans Mono" (font-family-list))
           (add-to-list 'initial-frame-alist '(font . "DejaVu Sans Mono-10"))
          (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10")))

;;helm 
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;;helm-gtags
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)


;;company-mode
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
;; semantic mode 
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)
 
;;function-args 
(require 'function-args)
(fa-config-default)
(global-set-key (kbd "C-<tab>") 'moo-complete)

;;ecb 
(require 'ecb)
(require 'ecb-autoloads)
(setq ecb-layout-name "left3")
(setq ecb-show-sources-in-directories-buffer 'always)
;;(setq ecb-compile-window-height 6)
;;; activate and deactivate ecb
(global-set-key (kbd "C-x C-;") 'ecb-activate)
(global-set-key (kbd "C-x C-'") 'ecb-deactivate)
;;; show/hide ecb window
(global-set-key (kbd "C-;") 'ecb-show-ecb-windows)
(global-set-key (kbd "C-'") 'ecb-hide-ecb-windows)
;;; quick navigation between ecb windows
(global-set-key (kbd "C-)") 'ecb-goto-window-edit1)
(global-set-key (kbd "C-!") 'ecb-goto-window-directories)
(global-set-key (kbd "C-@") 'ecb-goto-window-sources)
(global-set-key (kbd "C-#") 'ecb-goto-window-methods)
(global-set-key (kbd "C-$") 'ecb-goto-window-compilation)


;; custom style 
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
;; auto pair
(require 'autopair)
(autopair-global-mode 1)
(setq autopair-autowrap t)

;;compile command 
(global-set-key (kbd "C-b") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command t)
                               (call-interactively 'compile)))
;; highlight current line 
(global-hl-line-mode 1) 
;;flymake 
(require 'flymake)
(add-hook 'find-file-hook 'flymake-find-file-hook)
;;undo-tree
;;(require 'undo-tree)
;;paren match highlight
(show-paren-mode 1) ; turn on paren match highlighting
(setq show-paren-style 'expression) ; highlight entire bracket expression
;;show columns
(column-number-mode 1)
;;rencent file show 
(recentf-mode 1) ; keep a list of recently opened files

;;company-c-headers
(add-to-list 'company-backends 'company-c-headers)
;;(add-to-list 'company-backends 'company-c-headers)
;;(add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8.3/") 

;;customize short key 
(global-set-key (kbd "C-.") 'semantic-ia-fast-jump)
(global-set-key (kbd "C-M-p") 'beginning-of-defun)
(global-set-key (kbd "C-M-n") 'end-of-defun)
(global-set-key (kbd "M-s") 'helm-gtags-select)

;;linux  kernel include path 
;;(semantic-add-system-include "~/build/OV_Driver/omap4-v4l2-camera/include")



(defun copy-line (arg)
      "Copy lines (as many as prefix argument) in the kill ring"
      (interactive "p")
      (kill-ring-save (line-beginning-position)
                      (line-beginning-position (+ 1 arg)))
      (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key (kbd "C-c C-k") 'copy-line)


;;smex && window_number
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(require 'window-number)
(window-number-mode 1)
(global-set-key (kbd "C-x o") 'window-number-switch)
;;yasnippet 
(require 'yasnippet)
(yas-global-mode 1)

;; shell configuration
(setq shell-file-name "/bin/bash")
;;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t) 
;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)
(require 'multi-term)
(setq multi-term-program "/bin/bash")
;;TAB conflict with yasnippet
(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))
 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-linum-mode t)
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
