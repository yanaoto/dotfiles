;; @ key bind
; enable-BackSpace
(global-set-key "\C-h" 'delete-backward-char)

;; goto-line
(global-set-key (kbd "M-g") 'goto-line)


;; package.el setting
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


;; インストールするパッケージ
(defvar my/favorite-packages
  '(
    ;;;; for auto-complete
    ;; auto-complete fuzzy popup pos-tip

    ;;;; buffer utils
    ;; popwin elscreen yascroll buffer-move

    ;;;; flymake
    ;; flycheck flymake-jslint

    ;;;; go
    ;; go-mode

    ;;;; python
    ;; jedi

    ;;;; helm
    helm ;; helm-ag helm-descbinds helm-ls-git

    ;;;; git
    ;; magit git-gutter

    ;;;; snippet
    ;; yasnippet

    ;;;;mode
    ;; js2-mode ruby-mode cperl-mode 

    ;; doc
    eldoc
    eldoc-extension
    c-eldoc
    

    ;;;;etc
    ;; auto-async-byte-compile
    ;; direx
    ;; init-loader
    ;; markdown-mode
    ;; open-junk-file
    ;; recentf-ext
    color-theme
    point-undo
    redo+
    ))

;; my/favorite-packagesからインストールしていないパッケージをインストール
(dolist (package my/favorite-packages)
  (unless (package-installed-p package)
    (package-install package)))



;; helm
(require 'helm-config)


;;color theme
(when (and (require 'color-theme nil t) (window-system))
  (color-theme-initialize)
  (color-theme-clarity))

;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#500")
;; 選択領域の色
(set-face-background 'region "#555")

;; Hide startup
(setq inhibit-startup-screen t)

;; Erase the initial message of scratch
(setq initial-scratch-message "")

;; Full path of the file displayed in the title bar
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))
;; Line number display
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#800"
                    :height 0.9)

;; Line number format
(setq linum-format "%4d")

;; Highlight the range of brackets
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;; Color in the range of brackets
(set-face-background 'show-paren-match-face "#500")

;; Color of the selected region
(set-face-background 'region "#555")

;; Highlight trailing whitespace
;; (setq-default show-trailing-whitespace t)
;; (set-face-background 'trailing-whitespace "#b14770")

;; deal with a tab as whitespace
(setq-default indent-tabs-mode nil)

;; Tab Width
; (custom-set-variables '(tab-width 4))

;; yes or no to y or n
(fset 'yes-or-no-p 'y-or-n-p)
(defalias 'yes-or-no-p 'y-or-n-p)
;; View on the Recent Documents menu
(when (require 'recentf nil t)
  ;; increase the number of saved most recently opened files
  (setq recentf-max-saved-items 3000)
  ;; Display the number of recently used files
  (setq recentf-max-menu-items 10)
  (setq recentf-save-file "~/.recentf")
  ;; (setq recentf-exclude '(".recentf"))
  ;; (setq recentf-auto-cleanup 10)
   (setq recentf-auto-cleanup 'never)
  ;; (setq recentf-auto-cleanup '12:00pm)
  ;; (run-with-idle-timer 30 t 'recentf-save-list)
  )
(recentf-mode 1)

;; save the history of the mini-buffer
(savehist-mode 1)

;; increase the number of saved history of mini-buffer
(setq history-length 3000)

;; Leaving no history duplicate
(setq history-delete-duplicates t)

;; The line number displayed in the mode line
(line-number-mode t)

;; The column number displayed in the mode line
(column-number-mode t)
;;; winner-mode
(when (fboundp 'winner-mode)
  (winner-mode t))

;; global high light line mode
(global-hl-line-mode 0)

;; kill whole line
(setq kill-whole-line t)

;; message log max
(setq message-log-max 10000)
;; server start for emacs-client
(require 'server)
;; (setq server-socket-dir "~/Dropbox/.emacs.d/server")
(unless (server-running-p)
  (server-start))


;;point-undo
(require 'point-undo)
(define-key global-map [f12] 'point-undo)
(define-key global-map [S-f12] 'point-redo)

;;redo
(when (require 'redo+ nil t)
  (define-key global-map (kbd "C-_") 'redo))

;; uniquify
 (require 'uniquify)
;; (setq uniquify-buffer-name-style 'forward)
 (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
 (setq uniquify-ignore-buffers-re "*[^*]+*")

;;c-eldoc
(add-hook 'c-mode-hook
          (lambda ()
            (set (make-local-variable 'eldoc-idle-delay) 0.20)
            (c-turn-on-eldoc-mode)
            ))
;(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)
(add-hook 'c++-mode-hook 'c-turn-on-eldoc-mode)

;; eldoc
(require 'eldoc)
(require 'eldoc-extension)
(setq eldoc-idle-delay 0)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)


;; flymake
(when (require 'flymake nil t)
  ;; C
  ;; http://d.hatena.ne.jp/nyaasan/20071216/p1
  (defun flymake-c-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
           (local-file  (file-relative-name
                         temp-file
                         (file-name-directory buffer-file-name))))
      (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.\\(c\\|h\\|y\\l\\)$" flymake-c-init))
  ;; C++
  (defun flymake-cc-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
           (local-file  (file-relative-name
                         temp-file
                         (file-name-directory buffer-file-name))))
      (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.cpp$" flymake-cc-init))

  ;; Emacs Lisp
  ;; http://www.emacswiki.org/emacs/FlymakeElisp
  (defun flymake-elisp-init ()
    (unless (string-match "^ " (buffer-name))
      (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
             (local-file  (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
        (list
         (expand-file-name invocation-name invocation-directory)
         (list
          "-Q" "--batch" "--eval"
          (prin1-to-string
           (quote
            (dolist (file command-line-args-left)
              (with-temp-buffer
                (insert-file-contents file)
                (condition-case data
                    (scan-sexps (point-min) (point-max))
                  (scan-error
                   (goto-char(nth 2 data))
                   (princ (format "%s:%s: error: Unmatched bracket or quote\n"
                                  file (line-number-at-pos)))))))
            )
           )
          local-file)))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.el$" flymake-elisp-init))

  (add-hook 'emacs-lisp-mode-hook
            ;; workaround for (eq buffer-file-name nil)
            (function (lambda () (if buffer-file-name (flymake-mode)))))
  (add-hook 'c-mode-common-hook
            (lambda () (flymake-mode t)))
  (add-hook 'php-mode-hook
            (lambda () (flymake-mode t)))
  )

;; JAVA
;; http://www.emacswiki.org/emacs-ja/FlymakeJava-ja
;;(setq char_set "SHIFT_JIS")
(setq char_set "UTF-8")
(setq classpath
      (getenv "CLASS_PATH"))
(defun flymake-java-init ()
  (flymake-simple-make-init-impl
   'flymake-create-temp-with-folder-structure nil nil
   buffer-file-name
   'flymake-get-java-cmdline))
(defun flymake-get-java-cmdline
    (source base-dir)
  (list "javac"
        (if classpath
            (list "-classpath" classpath (concat "-J-Dfile.encoding=" char_set) "-encoding" char_set source)
          (list (concat "-J-Dfile.encoding=" char_set) "-encoding" char_set source))))
(push '("\\.java$" flymake-java-init) flymake-allowed-file-name-masks)

(set-variable 'flymake-log-level 9)
(setq flymake-start-syntax-check-on-newline nil)
(setq flymake-no-changes-timeout 10)
(add-hook 'java-mode-hook 'flymake-mode-on)



;; GUIの警告は表示しない
(setq flymake-gui-warnings-enabled nil)

;; 全てのファイルで flymakeを有効化
                                        ;(add-hook 'find-file-hook 'flymake-find-file-hook)

;; エラーメッセージをポップアップ表示
(defun flymake-popup-err-message ()
  "Display a menu with errors/warnings for current line if it has errors and/or warnings."
  (interactive)
  (let* ((line-no            (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data          (flymake-make-err-menu-data line-no line-err-info-list)))
    (if menu-data
        (popup-tip (mapconcat '(lambda (e) (nth 0 e))
                              (nth 1 menu-data)
                              "\n")))
    ))
;; ;; カーソルをエラー行に載せるとエラーメッセージをポップアップ表示
;; ;; anythingと干渉するようなのでコメントアウト 
;; (defadvice flymake-mode (before post-command-stuff activate compile)
;;   "エラー行にカーソルが当ったら自動的にエラーが minibuffer に表示されるように
;; post command hook に機能追加"
;;   (set (make-local-variable 'post-command-hook)
;;        (add-hook 'post-command-hook 'flymake-popup-err-message)))

;; キーバインド
(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)
;; (global-set-key "\C-cd" 'flymake-popup-err-message)

;; Objective-C 用設定
(defvar xcode:gccver "4.2.1")
(defvar xcode:sdkver "3.1.2")
(defvar xcode:sdkpath "/Developer/Platforms/iPhoneSimulator.platform/Developer")
(defvar xcode:sdk (concat xcode:sdkpath "/SDKs/iPhoneSimulator" xcode:sdkver ".sdk"))
(defvar flymake-objc-compiler (concat xcode:sdkpath "/usr/bin/gcc-" xcode:gccver))
(defvar flymake-objc-compile-default-options (list "-Wall" "-Wextra" "-fsyntax-only" "-ObjC" "-std=c99" "-isysroot" xcode:sdk))
(defvar flymake-last-position nil)
(defvar flymake-objc-compile-options '("-I."))
(defun flymake-objc-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list flymake-objc-compiler (append flymake-objc-compile-default-options flymake-objc-compile-options (list local-file)))))

(add-hook 'objc-mode-hook
          (lambda ()
            ;; 拡張子 m と h に対して flymake を有効にする設定 flymake-mode t の前に書く必要があります
            (push '("\\.m$" flymake-objc-init) flymake-allowed-file-name-masks)
            (push '("\\.h$" flymake-objc-init) flymake-allowed-file-name-masks)
            ;; 存在するファイルかつ書き込み可能ファイル時のみ flymake-mode を有効にします
            (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                (flymake-mode t))))



;; (add-hook 'java-mode-hook 'flymake-mode-on)
;; ;;(setq char_set "SHIFT_JIS")
;; (setq char_set "UTF-8")
;; (setq classpath
;;       (getenv "CLASS_PATH")
;; nil)
;; (defun flymake-java-init ()
;; (flymake-simple-make-init-impl
;;   'flymake-create-temp-with-folder-structure nil nil
;;   buffer-file-name
;;   'flymake-get-java-cmdline))
;; (defun flymake-get-java-cmdline
;; (source base-dir)
;; (list "javac"
;;   (if classpath
;;    (list "-classpath" classpath (concat "-J-Dfile.encoding=" char_set) "-encoding" char_set source)
;;    (list (concat "-J-Dfile.encoding=" char_set) "-encoding" char_set source))))
;; (push '("\\.java$" flymake-java-init) flymake-allowed-file-name-masks)
;; (add-hook 'java-mode-hook '(lambda ()
;;                             (flymake-mode t)))