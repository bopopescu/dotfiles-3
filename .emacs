;; debuger
;;(setq debug-on-error t)

;; load-path
;;(setq load-path (cons "~/.emacs.d/elisp" load-path))
;;====================
;; General
;;====================
;; load-pathを追加
(setq load-path (append
                 '("/Applications/Emacs.app/Contents/Resources/site-lisp"
		   "/Applications/MacPorts/Emacs.app/Contents/Resources/site-lisp"
		   "~/.emacs.d/elisp"
		   "~/.emacs.d/auto-install"
		   "~/.emacs.d/init"
		   "~/.emacs.d/navi2ch"
		   "~/.emacs.d/haskell-mode-2.8.0"
		   "~/.emacs.d/geben"
		   "~/.emacs.d/elisp/howm"
		   "/opt/local/share/emacs/site-lisp"
		   "/opt/local/share/emacs/site-lisp/howm"
		   "~/.emacs.d/vendor/ensime/elisp"
		   "~/.emacs.d/vendor/scala-mode"
		   ;; "/usr/local/Cellar/erlang/R14B03/lib/erlang/lib/tools-2.6.6.4/emacs"
		   )
                 load-path))

(setq exec-path (append
                 '("/opt/local/bin"
		   "/opt/local/sbin"
                   "/usr/bin"
		   "/bin"
                   "/usr/sbin"
		   "/sbin"
		   "/usr/local/bin"
		   "/usr/local/sbin"
                   "/usr/X11/bin"
		   "/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin"
		   ;; "/usr/local/Cellar/erlang/R14B03/bin"
		   )
                 exec-path))

;; 言語を日本語にする
(set-language-environment 'Japanese)
;; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; (add-to-list 'face-font-rescale-alist '(".*osaka-bold.*" . 0.3))

;; (add-to-list 'default-frame-alist
;;              '(font . "16-dot medium"))
;; (add-to-list 'default-frame-alist
;;              '(font . "-*-*-medium-r-normal--12-*-*-*-*-*-16-dot medium"))


;; (add-to-list 'default-frame-alist '(font . "fontset-default"))
;; ;; (set-frame-font "fontset-default")

;; (set-face-attribute 'default nil
;;                     :family "monaco"
;;                     :height 100)

;; (set-fontset-font "fontset-default"
;;                   'japanese-jisx0208
;;                   '("ヒラギノ丸ゴ pro w4*" . "jisx0208.*"))

;; (set-fontset-font "fontset-default"
;;                   'katakana-jisx0201
;;                   '("ヒラギノ丸ゴ pro w4*" . "jisx0201.*"))

;; (add-to-list 'face-font-rescale-alist
;;              `(,(encode-coding-string ".*ヒラギノ丸ゴ pro w4.*" 'emacs-mule) . 1.0))



(require 'install-elisp)
;; install-elisp-reposirory
(setq install-elisp-repository-directory "~/.emacs.d/elisp")
(setq mac-option-modifier 'meta)

;; zshを使う
(setq shell-file-name "/opt/local/bin/zsh")

;; 関連パッケージインストールバッジ
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)  ; 互換性確保

(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

;; anything関連ロード
(require 'anything-startup)
;; anything config
(require 'anything-config)
(setq anything-sources (list anything-c-source-buffers
                             anything-c-source-bookmarks
                             anything-c-source-recentf
                             anything-c-source-file-name-history
                             anything-c-source-locate))
(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "C-v") 'anything-next-source)
(define-key anything-map (kbd "M-v") 'anything-previous-source)
(global-set-key (kbd "C-;") 'anything)

;; 画面分割時defaultが左右に画面分割
(defun my-horizontally-split-window (buf)
  (delete-other-windows)
  (split-window-horizontally)
  (funcall (if anything-samewindow 'switch-to-buffer 'pop-to-buffer) buf))
(setq anything-display-function 'my-horizontally-split-window)

;; mmm-mode
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(set-face-background 'mmm-default-submode-face "#333333")
;; html系
(mmm-add-classes
 '((mmm-html-css-mode
    :submode css-mode
    :face mmm-code-submode-face
    :front "<style[^>]*>\\([^<]*\\)?\n[ \t]*</style>"
    )

   ;;    (html-php
   ;;     :submode php-mode
   ;;     :front "<\\?\\(php\\)?"
   ;;     :back "\\?>"
   ;;     )

   (mmm-html-javascript-mode
    :submode javascript-mode
    :face mmm-code-submode-face
    :front "<script[^>]*>\\([^<]*\\)?</script>"
    :back "</script>"
    )

   (mmm-ml-css-mode
    :submode css-mode
    :face mmm-code-submode-face
    :front "<style[^>]*>"
    :back "\n?[ \t]*</style>"
    )

   (mmm-ml-javascript-mode
    :submode javascript-mode
    :face mmm-code-submode-face
    :front "<script[^>]*>[^<]"
    :front-offset -1
    :back "\n?[ \t]*</script>"
    )

   (mmm-mxml-actionscript-mode
    :submode actionscript-mode
    :face mmm-code-submode-face
    :front "<mx:Script><!\\[CDATA\\["
    :back "[ \t]*\\]\\]></mx:Script>"
    )
   ))
(mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
(mmm-add-mode-ext-class 'sgml-mode nil 'mmm-html-css-mode)
(mmm-add-mode-ext-class 'sgml-mode nil 'mmm-html-javascript-mode)
(mmm-add-mode-ext-class 'xml-mode nil 'mmm-ml-css-mode)
(mmm-add-mode-ext-class 'xml-mode nil 'mmm-ml-javascript-mode)
(mmm-add-mode-ext-class 'xml-mode nil 'mmm-mxml-actionscript-mode)
;; 開いてるバッファをmmm-modeでパースしなおし
(global-set-key [f8] 'mmm-parse-buffer)

;; mmm-mode in php
;; (mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
;; (mmm-add-classes
;;  '((html-php
;;     :submode php-mode
;;     :front "<\\?\\(php\\)?"
;;     :back "\\?>")))
;; (add-to-list 'auto-mode-alist '("\\.php?\\'" . nxhtml-mode))

;; ;; うまく動かんちょっとしゅうせいが必要かも html nxhtml
;; (load-library "autostart")
;; (custom-set-variables
;;  '(indent-region-mode t)
;;  '(nxhtml-global-minor-mode t)
;;  '(nxhtml-global-validation-header-mode t)
;;  '(nxhtml-skip-welcome t))
;; (custom-set-faces)

;; Auto-complete
;;(require 'auto-complete-config)
(require 'auto-complete)
(require 'ac-company)
(require 'fuzzy)
(require 'popup)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;;(ac-config-default)
;; 対象の全てで補完を有効にする
(global-auto-complete-mode t)
;; enabled auto-complete-mode.
(add-to-list 'ac-modes 'erlang-mode 'haskell-mode)

;; auto complete etags
(require 'auto-complete-etags)

(setq ac-use-menu-map t)
;; デフォルトで設定済み
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)


;; php-complete
;; php-mode
;; 設定例

(require 'php-mode)
(setq auto-mode-alist
      (cons '("\\.php\\'" . php-mode) auto-mode-alist))

;;
(load-library "php-mode")
;;
(autoload 'php-mode "php-mode")

;; php  auto-complete
(add-hook
 'php-mode-hook
 (lambda ()
   ;;
   (setq php-mode-force-pear t)
   ;;
   (setq php-manual-path "/usr/local/share/php/doc/html")
   (setq php-manual-url "http://www.php.net/manual/ja/")
   ;;
   (c-set-style "K&R")
   ;;
   (setq tab-width 2)
   ;;
   (setq c-basic-offset 2)
   ;;
   (setq indent-tabs-mode t)
   ;; 連続する空白の一括削除 (必要なければコメントアウトする)
   (c-toggle-hungry-state t)
   ;; コメント行のインデント (必要なければコメントアウトする)
   (setq c-comment-only-line-offset 0)
   ;; コメントのスタイル (必要なければコメントアウトする)
   (setq comment-start "// "
         comment-end   ""
         comment-start-skip "// *")
   ;; インデント
   (define-key php-mode-map "\C-m" 'newline-and-indent)

   ;; php complete
   (require 'php-completion)
   (php-completion-mode t)
   (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
   (when (require 'auto-complete nil t)
     (make-variable-buffer-local 'ac-sources)
     (add-to-list 'ac-sources 'ac-source-php-completion)
     (auto-complete-mode t))))

;; geben
(autoload 'geben "geben" "PHP Debugger on Emacs" t)

;; javascript mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist (cons  "\\.\\(js\\|json\\|jsn\\|htc\\)\\'" 'js2-mode))
;;下は好みで tab幅を4にする設定
(add-hook 'js2-mode-hook
          (function
           (lambda ()
             (setq tab-width 4)
             (setq javascript-indent-level 4)
             (setq javascript-basic-offset tab-width)
             )))


;; erlang mode
; (setq erlang-root-dir "/usr/local/Cellar/erlang/R14B04")
; (require 'erlang-start)
; (add-hook 'erlang-mode-hook 'auto-complete-mode)
             ; (when (require 'auto-complete nil t)
; ;;               (make-variable-buffer-local 'ac-sources)
; ;;               (add-to-list 'ac-sources 'ac-source-php-completion)
               ; (auto-complete-mode t))


;; haskell-mode


;; (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))
(autoload 'haskell-mode "haskell-mode"
   "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
   "Major mode for editing literate Haskell scripts." t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
(add-hook 'haskell-mode-hook 'auto-complete-mode)
(load "auto-complete-haskellfunctions")

(setq haskell-literate-default 'latex)
(setq haskell-doc-idle-delay 0)

;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


;; ;(require 'ac-python)
;; ;(require 'pysmell)
;; (require 'python-pep8)
;; (require 'python-pylint)
;; (require 'lambda-mode)
;; (require 'autopair)
;; (require 'python)
;; ;(require 'auto-complete)
;; (require 'yasnippet)

;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; ;; Initialize Pymacs
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; ;; Initialize Rope
;; (pymacs-load "ropemacs" "rope-")
;; (setq ropemacs-enable-autoimport t)

;; ;; Initialize Yasnippet
;; ;Don't map TAB to yasnippet
;; ;In fact, set it to something we'll never use because
;; ;we'll only ever trigger it indirectly.
;; (setq yas/trigger-key (kbd "C-c <kp-multiply>"))
;; (yas/initialize)
;; (yas/load-directory "~/.emacs.d/snippets")



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Auto-completion
;; ;;;  Integrates:
;; ;;;   1) Rope
;; ;;;   2) Yasnippet
;; ;;;   all with AutoComplete.el
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun prefix-list-elements (list prefix)
;;   (let (value)
;;     (nreverse
;;      (dolist (element list value)
;;       (setq value (cons (format "%s%s" prefix element) value))))))
;; (defvar ac-source-rope
;;   '((candidates
;;      . (lambda ()
;;          (prefix-list-elements (rope-completions) ac-target))))
;;   "Source for Rope")
;; (defun ac-python-find ()
;;   "Python `ac-find-function'."
;;   (require 'thingatpt)
;;   (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
;;     (if (null symbol)
;;         (if (string= "." (buffer-substring (- (point) 1) (point)))
;;             (point)
;;           nil)
;;       symbol)))
;; (defun ac-python-candidate ()
;;   "Python `ac-candidates-function'"
;;   (let (candidates)
;;     (dolist (source ac-sources)
;;       (if (symbolp source)
;;           (setq source (symbol-value source)))
;;       (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
;;              (requires (cdr-safe (assq 'requires source)))
;;              cand)
;;         (if (or (null requires)
;;                 (>= (length ac-target) requires))
;;             (setq cand
;;                   (delq nil
;;                         (mapcar (lambda (candidate)
;;                                   (propertize candidate 'source source))
;;                                 (funcall (cdr (assq 'candidates source)))))))
;;         (if (and (> ac-limit 1)
;;                  (> (length cand) ac-limit))
;;             (setcdr (nthcdr (1- ac-limit) cand) nil))
;;         (setq candidates (append candidates cand))))
;;     (delete-dups candidates)))
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;                  (auto-complete-mode 1)
;;                  (set (make-local-variable 'ac-sources)
;;                       (append ac-sources '(ac-source-rope) '(ac-source-yasnippet)))
;;                  (set (make-local-variable 'ac-find-function) 'ac-python-find)
;;                  (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
;;                  (set (make-local-variable 'ac-auto-start) nil)))

;; ;;Ryan's python specific tab completion
;; (defun ryan-python-tab ()
;;   ; Try the following:
;;   ; 1) Do a yasnippet expansion
;;   ; 2) Do a Rope code completion
;;   ; 3) Do an indent
;;   (interactive)
;;   (if (eql (ac-start) 0)
;;       (indent-for-tab-command)))

;; (defadvice ac-start (before advice-turn-on-auto-start activate)
;;   (set (make-local-variable 'ac-auto-start) t))
;; (defadvice ac-cleanup (after advice-turn-off-auto-start activate)
;;   (set (make-local-variable 'ac-auto-start) nil))

;; (define-key python-mode-map "\t" 'ryan-python-tab)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; End Auto Completion
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; ;; (defvar is_emacs23 (>= emacs-major-version 23))

;; ;; (when is_emacs23
;; ;;   (defun python-partial-symbol ()
;; ;;     "Return the partial symbol before point (for completion)."
;; ;;     (let ((end (point))
;; ;;           (start (save-excursion
;; ;;                    (and (re-search-backward
;; ;;                          (rx (or buffer-start (regexp "[^[:alnum:]._]"))
;; ;;                              (group (1+ (regexp "[[:alnum:]._]"))) point)
;; ;;                          nil t)
;; ;;                         (match-beginning 1)))))
;; ;;       (if start (buffer-substring-no-properties start end))))
;; ;;   )

;; ;; (defun ac-python-candidates ()
;; ;;   (python-find-imports)
;; ;;   (car (read-from-string
;; ;;         (python-send-receive
;; ;;          (format "emacs.complete(%S,%s)"
;; ;;                  (python-partial-symbol)
;; ;;                  python-imports)))))

;; ;; (ac-define-source python
;; ;;   '((candidates . ac-python-candidates)
;; ;;     (prefix . (unless
;; ;;                   (save-excursion
;; ;;                     (re-search-backward "^import"
;; ;;                                         (save-excursion
;; ;;                                           (re-search-backward "^")) t))
;; ;;                 (let ((symbol
;; ;;                        (python-partial-symbol)
;; ;;                        ))
;; ;;                   (if symbol
;; ;;                       (save-excursion (search-backward symbol))))))
;; ;;     (symbol . "py-f")))

;; ;; (add-hook
;; ;;  'python-mode-hook
;; ;;  '(lambda ()
;; ;;     (add-to-list 'ac-sources 'ac-source-python)
;; ;;     ))

;; ;; (add-hook
;; ;;  'inferior-python-mode-hook
;; ;;  '(lambda ()
;; ;;     (define-key inferior-python-mode-map "\C-c\C-f" 'python-describe-symbol)
;; ;;     (define-key inferior-python-mode-map "\C-c\C-z" 'kill-buffer-and-window)
;; ;;     (process-kill-without-query (get-process "Python"))
;; ;;     ))


;; ;; ;; pysmell
;; ;; (add-hook 'python-mode-hook (lambda () (pysmell-mode 1)))

;; ;; (defvar ac-source-pysmell
;; ;;   '((candidates
;; ;;      . (lambda ()
;; ;;          (require 'pysmell)
;; ;;          (pysmell-get-all-completions))))
;; ;;     "~/")

;; ;; (add-hook 'python-mode-hook
;; ;;     '(lambda ()
;; ;;         (set (make-local-variable 'ac-sources) (append ac-sources '(ac-source-pysmell)))))

;; ;; ;; ;; pymacs
;; ;; (autoload 'pymacs-apply "pymacs")
;; ;; (autoload 'pymacs-call "pymacs")
;; ;; (autoload 'pymacs-eval "pymacs" nil t)
;; ;; (autoload 'pymacs-exec "pymacs" nil t)
;; ;; (autoload 'pymacs-load "pymacs" nil t)
;; ;; (eval-after-load "pymacs"
;; ;;   '(add-to-list 'pymacs-load-path "~/emacs.d/pymacs-elisp"))

;; ;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; ;; (setq interpreter-mode-alist (cons '("python" . python-mode)
;; ;;                                    interpreter-mode-alist))
;; ;; (autoload 'python-mode "python-mode" "Python editing mode." t)
;; ;; (add-hook 'python-mode-hook
;; ;;           '(lambda()
;; ;;              (require 'pycomplete)))

;; ;; (global-set-key (kbd "M-h") 'ac-complete-pycomplete-pycomplete)

;; ;; (defun ac-complete-pycomplete-pycomplete ()
;; ;;   (interactive)
;; ;;   (auto-complete '(ac-source-python)))

;; ;; (setq ac-source-python
;; ;;   '((prefix "\\(?:\\.\\|->\\)\\(\\(?:[a-zA-Z_][a-zA-Z0-9_]*\\)?\\)" nil 1)
;; ;;     (candidates . ac-py-candidates)
;; ;;     (requires . 0)))

;; ;; (defun ac-py-candidates ()
;; ;;   (pycomplete-pycomplete (py-symbol-near-point) (py-find-global-imports)))
;; ;; (defun my-ac-python-mode ()
;; ;;   (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary)))
;; ;; (add-hook 'python-mode-hook 'my-ac-python-mode)


;; ;; autopair
;; ; (autoload 'autopair-global-mode "autopair" nil t)
;; ; (autopair-global-mode)

;; ; (add-hook 'python-mode-hook
;;           ; #'(lambda ()
;;               ; (push '(?' . ?')
;;                     ; (getf autopair-extra-pairs :code))
;;               ; (setq autopair-handle-action-fns
;;                     ; (list #'autopair-default-handle-action
;;                           ; #'autopair-python-triple-quote-action))))

;; ;; ;;末尾空白除去(半角のみ)
;; ;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

;; ;; ;;lambda
;; ;; (add-hook 'python-mode-hook #'lambda-mode 1)

;; ;; (defun annotate-pdb ()
;; ;;  (interactive)
;; ;;  (highlight-lines-matching-regexp "import pdb")
;; ;;  (highlight-lines-matching-regexp "import debug")
;; ;;  (highlight-lines-matching-regexp "pdb.set_trace()"))
;; ;; (add-hook 'python-mode-hook 'annotate-pdb)

;; ;; ;;debug
;; ;; ;; (defun python-add-breakpoint ()
;; ;; ;;   (interactive)
;; ;; ;;   (py-newline-and-indent)
;; ;; ;;   (insert "import ipdb; ipdb.set_trace()")
;; ;; ;;   (highlight-lines-matching-regexp "^[   ]*import ipdb; ipdb.set_trace()"))
;; ;; ;; (define-key py-mode-map (kbd "C-c C-t") 'python-add-breakpoint)

;; ;; ;;python括弧
;; ;; (add-hook 'python-mode-hook
;; ;;           (lambda ()
;; ;;             (define-key python-mode-map "\"" 'electric-pair)
;; ;;             (define-key python-mode-map "\'" 'electric-pair)
;; ;;             (define-key python-mode-map "(" 'electric-pair)
;; ;;             (define-key python-mode-map "[" 'electric-pair)
;; ;;             (define-key python-mode-map "{" 'electric-pair)))
;; ;; (defun electric-pair ()
;; ;;   "Insert character pair without sournding spaces"
;; ;;   (interactive)
;; ;;   (let (parens-require-spaces)
;; ;;     (insert-pair)))

;; ;; ;; python indent
;; ;; (add-hook 'python-mode-hook
;; ;;     '(lambda ()
;; ;;        (define-key python-mode-map "\C-m" 'newline-and-indent)
;; ;;        ))


;; nxhtml

;; css-mode
(autoload 'css-mode "css-mode" nil t)
(setq auto-mode-alist (cons '("\\.css$" . css-mode) auto-mode-alist))

(setq css-indent-level 4)

;; apache-mode
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

;; dsvn subversion
          ;(autoload 'svn-status "dsvn" "Run `svn status'." t)
          ;(autoload 'svn-update "dsvn" "Run `svn update'." t)

;; Show white space
(require 'show-wspace)

;; 行数表示
(line-number-mode t)
;; goto-line
(global-set-key "\C-xl" 'goto-line)

;; wondowをmac UI
(when (eq window-system 'mac)
  (add-hook 'window-setup-hook
      (lambda ()
        (setq mac-autohide-menubar-on-maximize t)
        ;; (set-frame-parameter nil 'fullscreen 'fullboth)
        )))


;; sppedbar
(require 'sr-speedbar)

;; 右側に表示
(setq sr-speedbar-right-side t)

(defun my-speedbar-expand-line ()
  (interactive)
  (if (= (point-max) (progn (speedbar-expand-line) (point-max)))
      (save-current-buffer
        (speedbar-edit-line))))

(when (locate-library "speedbar")
  (require 'speedbar)
  ;; "a" で無視ファイル表示/非表示のトグル
  (define-key speedbar-file-key-map "a" 'speedbar-toggle-show-all-files)
  ;; ← や → でもディレクトリを開閉 ;;デフォルト: "=" "+", "-"
  (define-key speedbar-file-key-map [right] 'my-speedbar-expand-line)
  (define-key speedbar-file-key-map "\C-f" 'my-speedbar-expand-line)
  (define-key speedbar-file-key-map [left] 'speedbar-contract-line)
  (define-key speedbar-file-key-map "\C-b" 'speedbar-contract-line)
  ;; BS でも上位ディレクトリへ ;;デフォルト: "U"
  (define-key speedbar-file-key-map [backspace] 'speedbar-up-directory)
  (define-key speedbar-file-key-map "\C-h" 'speedbar-up-directory)
  ;; 起動位置を直接指定する
  (setq speedbar-frame-parameters
        (append (list '(top . 40)
                      '(left . 780)
                      '(width . 25))
                speedbar-frame-parameters)))

;; speedbar に拡張子を登録
(add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension '("js" "as" "html" "css" "php" "py"))))

(global-set-key (kbd "<f6>") 'sr-speedbar-toggle)


;; full screen
;; (defun mac-toggle-max-window ()
;;   (interactive)
;;   (if (frame-parameter nil 'fullscreen)
;;       (set-frame-parameter nil 'fullscreen nil)
;;     (set-frame-parameter nil 'fullscreen 'fullboth)))
;; (global-set-key "\C-cm" 'mac-toggle-max-window)

;; Carbon Emacsの設定で入れられた. メニューを隠したり．
(custom-set-variables
 '(display-time-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))
(custom-set-faces)

;; Color
(if window-system (progn
        (set-background-color "Black")
        (set-foreground-color "LightGray")
        (set-cursor-color "Gray")
        (set-frame-parameter nil 'alpha 80)
        ))

;; Macのキーバインドを使う
          ;(mac-key-mode 1)

;; シフト + 矢印で範囲選択
(setq pc-select-selection-keys-only t)
(pc-selection-mode 1)

;; ビープ音を消す
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; スタートアップページを表示しない
(setq inhibit-startup-message t)

;; 対応する括弧を光らせる。
(show-paren-mode 1)

;; 編集行のハイライト
(global-hl-line-mode)

;;
;; backup file
;;______________________________________________________________________
;; バックアップファイルを作らない
(setq backup-inhibited t)
(setq make-backup-files nil)

;; ElScreenの有効化
          ;(require 'elscreen)
;; PrefixキーをC-zに割り当て
          ;(elscreen-set-prefix-key "\C-z")
          ;(if window-system
          ;    (define-key elscreen-map "\C-z" 'iconify-or-deiconify-frame)
          ;  (define-key elscreen-map "\C-z" 'suspend-emacs))

;; linum.el(行番号の表示)
(require 'linum)
;; デフォルトでONにする
(global-linum-mode 0)
;; F5キーにON/OFFの切り替えを割り当てる
(global-set-key [f5] 'linum-mode)
;; 5桁とスペースの領域を割り当てる
(setq linum-format "%5d ")

;; jaspaceを有効化
(require 'jaspace)
;; 全角空白を表示させる
(setq jaspace-alternate-jaspace-string "□")
;; タブを表示
(setq jaspace-highlight-tabs t)
;; フック
(add-hook 'text-mode-hook 'jaspace-mode)

;; backup dir
(setq backup-directory "~/.emacs.d/backup")
(if (and (boundp 'backup-directory)
   (not (fboundp 'make-backup-file-name-original)))
    (progn
      (fset 'make-backup-file-name-original
      (symbol-function 'make-backup-file-name))
      (defun make-backup-file-name (filename)
  (if (file-directory-p backup-directory)
      (concat backup-directory "/" (file-name-nondirectory filename))
    (make-backup-file-name-original filename)))))
;;;終了時に自動生成されたオートセーブファイルを削除行う
(setq delete-auto-save-files t)

;; back space
(global-set-key "\C-h" 'delete-backward-char)

;; undo redo
;; C-_がうまくうごかないのでデフォルトのキーバインドを無効にするのを試す
(when (require 'redo+ nil t)
  (define-key ctl-x-map (if window-system "U" "r") 'redo)
  (define-key global-map  [?\C-?] 'redo))
          ;(define-key global-map  [?\C-\S-/] 'redo)
          ;(define-key global-map "\C-\S-/" 'redo)
          ;(define-key global-map "\C-\S-_" 'redo)) )
(setq undo-no-redo t)
(setq undo-limit 600000)
(setq undo-strong-limit 900000)
;; undo tree
(require 'undo-tree)
(global-undo-tree-mode)

;; one Key 使い方わからん
;; (require 'one-key)
;; (require 'one-key-default)   ; one-key.el も一緒に読み込んでくれる
;; (require 'one-key-config)    ; one-key.el をより便利にする
;; (one-key-default-setup-keys) ; one-key- で始まるメニュー使える様になる
;;(define-key global-map "\C-x" 'one-key-menu-C-x) ;; C-x にコマンドを定義


;; C-tで画面分割連続押しでフォーカス移動
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)

;; grep系keyバインド
;;(global-set-key [?\C-c?\C-\S-g] 'anything-grep)
;;(global-set-key "\C-c\C-g" 'anything-project-grep)
(global-set-key "\C-c\C-g" 'grep-find)

;; tags
(global-set-key [?\C-c?\C-\S-g] 'tags-search)
;(require 'anything-etags)
;(global-set-key (kbd "M-/") 'anything-etags-select-from-here)
;;(require 'key-chord)
;; (setq key-chord-two-keys-delay 0.04)
;; (key-chord-mode 1)
;; (key-chord-define-global ",." 'anything-etags-select-from-here)



;; 関数名を表示
(which-func-mode 1)
;; all meger mode enabled.
(setq which-func-modes t)
;; 上部に表示
;; (delete (assoc 'which-funcmode mode-line-format) mode-line-format)
;; (setq-default header-line-format '(which-func-mode ("" which-func-format)))


;; anything-frep list
          ;(setq anything-grep-alist
;; 全バッファのファイル名においてegrepをかける。moccurの代わり。
          ;      '(("buffers" ("egrep -Hin %s $buffers" "/"))
;; ~/ 以下から再帰的にegrepをかける。不要なファイルは除かれる。
          ;  ("home" ("ack | xargs egrep -Hin %s" "~/"))
;; /usr/loacal/share/php/doc から *.html に対してegrepをかける。
          ;  ("phpdoc" ("egrep -Hin %s *.html" "/usr/loacal/share/php/doc/"))
;; ~/ruby以下の全Rubyスクリプトと~/bin以下のファイルをまとめて検索する。
          ;  ("~/bin and ~/ruby"
          ;   ("ack -afG 'rb$' | xargs egrep -Hin %s" "~/ruby")
          ;   ("ack | xargs egrep -Hin %s" "~/bin"))
;; ~/smartacademy/ferris 以下から再帰的に 文字列検索 ark をかける。不要なファイルは除かれる。
          ;  ("ferris" ("ack %s" "~/smartacademy/ferris"))))

;; anything-grep-alistでやりたいことがこれでおkなので上記はコメント
;; ディレクトリは検索からのぞく設定
(require 'anything-project)
(setq ap:project-files-filters
      (list
       (lambda (files)
   (remove-if 'file-directory-p files))))

;; file検索
(global-set-key [?\C-c?\C-r] 'anything-project)

;; [M-a]で最後に編集した箇所へ辿る
;; [M-e]で編集箇所を逆方向に辿る
;; うまく動かん一度でフォルトのキーバインドを無効にする必要がある
;; http://www.emacswiki.org/cgi-bin/wiki/goto-chg.el
;;(require 'goto-chg)
;; (global-set-key (kbd "M-a") 'goto-last-change)
;; (global-set-key (kbd "M-e") 'goto-last-change-reverse)

;; M-a M-e を M-n M-p に当てる
(global-set-key (kbd "M-p") 'backward-sentence)
(global-set-key (kbd "M-n") 'forward-sentence)

;; 画面文字折り返し
(setq truncate-partial-width-windows nil)

;; session
(require 'session)
;;(desktop-save-mode 1)

;; desktop file
;; setq desktop-files-not-to-save "\\(^/[^/:]*:\\|\\.diary$\\)")
;; (autoload 'desktop-save "desktop" nil t)
;; (autoload 'desktop-clear "desktop" nil t)
;; (autoload 'desktop-load-default "desktop" nil t)
;; (autoload 'desktop-remove "desktop" nil t)
;; (desktop-read)
;; (add-hook 'kill-emacs-hook 'desktop-save-in-desktop-dir)

;; 以前編集していた場所にフォーカスを当てる
(load "saveplace")
(setq-default save-place t)

;; タブをタブとして消す
(global-set-key [backspace] 'backward-delete-char)

;; マウスのホイールスクロールスピードを調節
;; (連続して回しているととんでもない早さになってしまう。特にlogicoolのマウス)
(global-set-key [wheel-up] '(lambda () "" (interactive) (scroll-down 1)))
(global-set-key [wheel-down] '(lambda () "" (interactive) (scroll-up 1)))
(global-set-key [double-wheel-up] '(lambda () "" (interactive) (scroll-down 1)))
(global-set-key [double-wheel-down] '(lambda () "" (interactive) (scroll-up 1)))
(global-set-key [triple-wheel-up] '(lambda () "" (interactive) (scroll-down 2)))
(global-set-key [triple-wheel-down] '(lambda () "" (interactive) (scroll-up 2)))

(setq c-tab-always-indent t)   ; [TAB］キーでインデント実施

;; C-aで文頭に移動
(defun beggining-of-physical-indented-line (current-point)
  "インデント文字を飛ばした行頭に戻る。
ただし、ポイントから行頭までの間にインデント文字しかない場合は、行頭に戻る。"
  (interactive "d")
  (let ((line
         (save-excursion
           (buffer-substring-no-properties
            (progn (physical-line-beginning-of-line) (point))
            current-point)))
        (phys-line-head-pos
         (save-excursion
           (progn (physical-line-beginning-of-line) (point))))
        (line-head-pos
         (save-excursion
           (progn (beginning-of-line) (point)))))
    (if (or (not (eq phys-line-head-pos line-head-pos))
            (string-match "^[ \t]+$" line))
        (physical-line-beginning-of-line)
      (back-to-indentation))))
(global-set-key "\C-a" 'beggining-of-physical-indented-line )

;; For Emacs on Mac OS X http://emacsformacosx.com/
;; Opens files in the existing frame instead of making new ones.
(setq ns-pop-up-frames nil)


;; ファイル名がかぶった場合のバッファ名
(require 'uniquify)
; finename<dir>
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
; 対象外 *
(setq uniquify-ignore-buffers-rs "*[^*]+*")

;; 対応する括弧
(add-hook 'c-mode-common-hook
         '(lambda()
            ;; 対応する括弧の挿入
            (make-variable-buffer-local 'skeleton-pair)
            (make-variable-buffer-local 'skeleton-pair-on-word)
            (setq skeleton-pair-on-word t)
            (setq skeleton-pair t)
            (make-variable-buffer-local 'skeleton-pair-alist)
            (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
            (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
            (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
            (local-set-key (kbd "`") 'skeleton-pair-insert-maybe)
            (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
            ))

;; C-kで行全体を削除
;; (setq kill-whole-line t)
;; (global-set-key "\C-k" 'kill-whole-line)

;; カーソル移動を物理行単位に
(require 'physical-line)
(setq-default physical-line-mode t)
          ; dired-modeは論理行移動のままにする
(setq physical-line-ignoring-mode-list '(dired-mode))

;; 改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; 1行ずつスクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; for shell-mode

;;C-c cで選択範囲をコメントorコメントアウト
(global-set-key "\C-cc" 'comment-or-uncomment-region)

;;yes/noをy/nに変換
(fset 'yes-or-no-p 'y-or-n-p)

;;set default browser
(setq browse-url-browser-function 'browse-url-firefox
      browse-url-new-window-flag t
      browse-url-firefox-new-window-is-tab t)

;; コピペ summery表示
(global-set-key "\M-y" 'anything-show-kill-ring)

;; ssh root とか sshが重いかも
(require 'tramp)

;; 2ch
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)





;; dired:
;;本日変更ファイルを強調
;; (defface my-face-f-2 '((t (:foreground "GreenYellow"))) nil)
;; (defvar my-face-f-2 'my-face-f-2)
;; (defun my-dired-today-search (arg)
;;   "Fontlock search function for dired."
;;   (search-forward-regexp
;;    (concat (format-time-string "%b %e" (current-time)) " [0-9]....") arg t))
;; (add-hook 'dired-mode-hook
;;           '(lambda ()
;;              (font-lock-add-keywords
;;               major-mode
;;               (list
;;                '(my-dired-today-search . my-face-f-2)


;; load-init
(load "init-flymake")
(load "init-flymake-mine")

;; howm
(load "init-howm")



;; growl通知w
(defun growlnotify-after-save-hook ()
  (shell-command
   (format "growlnotify -m \"Emacs: ファイル %s を保存しました\""
       (buffer-name (current-buffer)))))
(add-hook 'after-save-hook 'growlnotify-after-save-hook)


          ; zsh
(require 'zlc)
(setq zlc-select-completion-immediately t)
(let ((map minibuffer-local-map))
  ;;; like menu select
  (define-key map (kbd "<down>")  'zlc-select-next-vertical)
  (define-key map (kbd "<up>")    'zlc-select-previous-vertical)
  (define-key map (kbd "<right>") 'zlc-select-next)
  (define-key map (kbd "<left>")  'zlc-select-previous)

  ;;; reset selection
  (define-key map (kbd "C-c") 'zlc-reset)
  )


;; (require 'gtags)

;; ;; gtags
;; (global-set-key (kbd "C-,") 'gtags-find-tag)
;; (global-set-key (kbd "C-<") 'gtags-pop-stack)
;; (define-key gtags-mode-map (kbd "C-i") 'gtags-find-tag) ;; 関数の定義元へ移動
;; (define-key gtags-mode-map (kbd "C-u") 'gtags-pop-stack) ;; 前のバッファへ戻る
;; (define-key gtags-mode-map "\M-," 'gtags-find-rtag) ;; 関数の参照元の一覧を表示
;; (define-key gtags-mode-map (kbd "C-.") 'gtags-find-symbol) ;; 変数の定義元と参照元の一覧を表示
;; (add-hook 'php-mode-hook
;;           (lambda ()
;;             (gtags-mode 1)
;;             (setq gtags-libpath `((,(expand-file-name "~/.tags/php") . "/opt/local/lib/php")
;;                                   (,(expand-file-name "~/.tags/php_zend") . "/var/www/Zend/ZendFramework-1.10.1-minimal/library")))))
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (gtags-mode 1)
;;             (setq gtags-libpath `((,(expand-file-name "~/.tags/python") . "/opt/local/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6"))))
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (gtags-mode 1)
;;             (setq gtags-libpath `((,(expand-file-name "~/.tags/c") . "/usr/include")))))
;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (gtags-mode 1)
;;             (setq gtags-libpath `((,(expand-file-name "~/.tags/haxe") . "/usr/local/haxe")))))
;; (add-hook 'gud-mode-hook
;;           (lambda ()
;;             (gtags-mode 1)))
;; (add-hook 'ruby-mode-hook
;;           (lambda ()
;;             (gtags-mode 1)
;;             (setq gtags-libpath `((,(expand-file-name "~/.tags/ruby") . "/usr/lib/ruby/1.8")))))
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (gtags-mode 1)
;;             (setq gtags-libpath `((,(expand-file-name "~/.tags/python") . " /usr/lib/python2.5")))))

;; auto-complete-gtags
;;(require 'auto-complete-gtags)

;; anything-gtags
;; (require 'anything-gtags)
;; (global-set-key (kbd "C-,") 'anything-gtags-select)
;; (global-set-key (kbd "C-<") 'anything-gtags-resume)


;; ;; Emacs shell ansi-termでエラーが出るのでコメントアウト
;; (load "init-shell")


          ;直そうと思ったがだめだった
;; (require 'term)
;; (defvar ansi-term-after-hook nil)
;; (add-hook 'ansi-term-after-hook
;;         (function
;;           (lambda ()
;;              (define-key term-raw-map "\C-x\C-v" '(lambda ()(interactive)(ansi-term "/bin/bash")))
;;              (define-key term-raw-map "\C-c\C-c" 'my-term-line-char-switch))))

;; (defadvice ansi-term (after ansi-term-after-advice (arg))
;;   "run hook as after advice"
;;   (run-hooks 'ansi-term-after-hook))
;; (ad-activate 'ansi-term)

;; (defun my-term-line-char-switch()
;;   (interactive)
;;   (if (term-in-line-mode) (term-char-mode)
;;     (if (term-in-char-mode) (term-line-mode))))

;; (add-hook 'term-mode-hook
;;         (function
;;           (lambda ()
;;                 (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
;;                 (make-local-variable 'mouse-yank-at-point)
;;                 (make-local-variable 'transient-mark-mode)
;;                 (setq mouse-yank-at-point t)
;;                 (setq transient-mark-mode t)
;;                 (auto-fill-mode -1)
;;         (setq tab-width 4)
;;                 (define-key term-mode-map "\C-i" 'term-dynamic-complete)
;;                 (define-key term-mode-map "\C-m" 'term-send-input))))


          ;
          ; since emacs 23
          ;

          ;command キーと Option キーの動作を逆にしたい場合は以下のような設定をします。
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; 垂直スクロール用のスクロールバーを付けない
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
          ; 背景の透過
(add-to-list 'default-frame-alist '(alpha . (92 70)))

;; 等幅のフォントセットを幾つか作成予定

(when (find-font (font-spec :family "Menlo"))
  ;; ヒラギノ 角ゴ ProN + Menlo
  (create-fontset-from-ascii-font "Menlo-14" nil "menlokakugo")
  (set-fontset-font "fontset-menlokakugo"
                    'unicode
                    (font-spec :family "Hiragino Kaku Gothic ProN" :size 16))
  ;; 確認用 (set-frame-font "fontset-menlokakugo")
  ;; (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))  ;; 実際に設定する場合
  )


;; フォントロックの設定
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t)
  ;;(setq font-lock-maximum-decoration t)
  (setq font-lock-support-mode 'jit-lock-mode))

;; タブ文字、全角空白、文末の空白の色付け
;; @see http://www.emacswiki.org/emacs/WhiteSpace
;; @see http://xahlee.org/emacs/whitespace-mode.html
(setq whitespace-style '(spaces tabs newline space-mark tab-mark newline-mark))

;; タブ文字、全角空白、文末の空白の色付け
;; font-lockに対応したモードでしか動作しません
(defface my-mark-tabs
  '((t (:foreground "red" :underline t)))
  nil :group 'skt)
(defface my-mark-whitespace
  '((t (:background "gray")))
  nil :group 'skt)
(defface my-mark-lineendspaces
  '((t (:foreground "SteelBlue" :underline t)))
  nil :group 'skt)

(defvar my-mark-tabs 'my-mark-tabs)
(defvar my-mark-whitespace 'my-mark-whitespace)
(defvar my-mark-lineendspaces 'my-mark-lineendspaces)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("\t" 0 my-mark-tabs append)
     ("　" 0 my-mark-whitespace append)
     ;;     ("[ \t]+$" 0 my-mark-lineendspaces append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; 行末の空白を表示
(setq-default show-trailing-whitespace t)
;; EOB を表示
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; 変更点に色付け
;; (global-highlight-changes-mode t)
;; (setq highlight-changes-visibility-initial-state t)
;; (global-set-key (kbd "M-]") 'highlight-changes-next-change)
;; (global-set-key (kbd "M-[")  'highlight-changes-previous-change)


;; full path
(setq frame-title-format '(buffer-file-name "%f" ("%b")))


;; show-paren-mode 1
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#ffff00" :weight 'extra-bold)


;; color-theme
(setq color-theme-load-all-themes nil)
(setq color-theme-libraries nil)
(require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (cond
;;       (mac-p
;;        (require 'color-theme-deep-blue)
;;        (color-theme-deep-blue)
;;        )
;;       (windows-p
;;        (require 'color-theme-ntemacs)
;;        (color-theme-ntemacs))
;;       )))

(when (>= emacs-major-version 23)
  (set-face-attribute 'default nil
          :family "monaco"
          :height 110)
  (set-fontset-font
   (frame-parameter nil 'font)
   'japanese-jisx0208
   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
  (set-fontset-font
   (frame-parameter nil 'font)
   'japanese-jisx0212
   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
  (set-fontset-font
   (frame-parameter nil 'font)
   'mule-unicode-0100-24ff
   '("monaco" . "iso10646-1"))
  (setq face-font-rescale-alist
  '(("^-apple-hiragino.*" . 1.2)
    (".*osaka-bold.*" . 1.2)
    (".*osaka-medium.*" . 1.2)
    (".*courier-bold-.*-mac-roman" . 1.0)
    (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
    (".*monaco-bold-.*-mac-roman" . 0.9)
    ("-cdac$" . 1.3))))

          ; ドラッグアンドドロップ
(define-key global-map [ns-drag-file] 'ns-find-file)

;;; リージョンをインデント
;; バッファ全体をインデント
(define-key global-map (kbd "C-<f7>") (kbd "C-x h TAB"))

;;; color-moccur.elの設定
(require 'color-moccur)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
;; migemoがrequireできる環境ならmigemoを使う
(when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
  (setq moccur-use-migemo t))

;;; anything-c-moccurの設定
(require 'anything-c-moccur)
;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
(setq anything-c-moccur-anything-idle-delay 0.2 ;`anything-idle-delay'
      anything-c-moccur-higligt-info-line-flag t ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
      anything-c-moccur-enable-auto-look-flag t ; 現在選択中の候補の位置を他のwindowに表示する
      anything-c-moccur-enable-initial-pattern t) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする

;; インクリメンタルサーチとoccur合体
;; (setq moccur-split-word t)
;; (global-set-key (kbd "M-s") 'anything-c-moccur-occur-by-moccur)

;;; キーバインドの割当(好みに合わせて設定してください)
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur) ;ディレクトリ
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;; (save-window-excursion (shell-command (format "emacs-test -l %s %s &" buffer-file-name buffer-file-name)))
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get/")
;; (require 'el-get)
;; (load "el-get.el")
;; ;; 初期化ファイルのワイルドカードを指定する
;; (setq el-get-init-files-pattern "~/emacs.d/elisp/[0-9]*.el")
;; (setq el-get-sources (el-get:packages))
;; (el-get)



;; adds grep-edit commands
(require 'grep-edit)


;; ecmascript
(require 'ecmascript-mode)


;; joseph-autopair
(require 'joseph-autopair)
(toggle-joseph-auto-pair-mode)
(custom-set-variables
 '(joseph-autopair-alist
   (quote
    ((emacs-lisp-mode ("\"" "\"") ("`" "'") ("(" ")") ("[" "]"))
     (lisp-interaction-mode ("\"" "\"") ("`" "'") ("(" ")") ("[" "]"))
     (c-mode ("\"" "\"") ("'" "'") ("(" ")") ("[" "]") ("{" (joseph-autopair-newline-indent-insert "}")))
     (php-mode ("\"" "\"") ("'" "'") ("(" ")") ("[" "]") ("{" (joseph-autopair-newline-indent-insert "}")))
     (java-mode ("\"" "\"") ("'" "'") ("(" ")") ("[" "]") ("{" (joseph-autopair-newline-indent-insert "}")))
     (sh-mode ("if " (joseph-autopair-newline-indent-insert "fi")) ("begin " (progn (insert " end") (end-of-line))))))))

; 末尾空白

(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; scala
(require 'scala-mode-auto)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))

;; scala ensime
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

