(require 'popup-switcher)
(global-set-key "\C-xo" 'psw-switch-buffer)
(setq psw-in-window-center t)
(setq psw-use-flx t)
;; Activate semantic
;(semantic-mode 1)

;; Load contrib library
;; (add-to-list 'load-path "~/.emacs.d/cedet/contrib/")
;; (require 'eassist)

;; (eval-after-load "eassist"
;;  '(global-set-key [f3] 'psw-switch-function))
 (setq popup-select-windows 2)
