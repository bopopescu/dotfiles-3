;;; flymake
(when (require 'flymake nil t))
(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)
;;(global-set-key "\C-cd" 'credmp/flymake-display-err-minibuf)
(defface my-face-spc-at-eol  '((t (:foreground "Red" :underline t))) nil :group 'my-faces)
(custom-set-faces
 '(flymake-errline ((((class color)) (:foreground "Red" :underline t))))
 '(flymake-warnline ((((class color)) (:foreground "Red" :underline t)))))

;; flymake 現在行のエラーをpopup.elのツールチップで表示する
;; (require 'popup)
;; (defun flymake-display-err-menu-for-current-line ()
;;   (interactive)
;;   (let* ((line-yno (flymake-current-line-no))
;;          (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no))))
;;     (when line-err-info-list
;;       (let* ((count (length line-err-info-list))
;;              (menu-item-text nil))
;;         (while (> count 0)
;;           (setq menu-item-text (flymake-ler-text (nth (1- count) line-err-info-list)))
;;           (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
;;                  (line (flymake-ler-line (nth (1- count) line-err-info-list))))
;;             (if file
;;                 (setq menu-item-text (concat menu-item-text " - " file "(" (format "%d" line) ")"))))
;;           (setq count (1- count))
;;           (if (> count 0) (setq menu-item-text (concat menu-item-text "\n")))
;;           )
;;         (popup-tip menu-item-text)))))

;; python
(defun flymake-python-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "pyflakes" (list local-file))))

(defconst flymake-allowed-python-file-name-masks '(("\\.py$" flymake-python-init)))
(defvar flymake-python-err-line-patterns '(("\\(.*\\):\\([0-9]+\\):\\(.*\\)" 1 2 nil 3)))

(defun flymake-python-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-python-file-name-masks))
  (setq flymake-err-line-patterns flymake-python-err-line-patterns)
  (flymake-mode t))
(add-hook 'python-mode-hook '(lambda () (flymake-python-load)))


;; haskell
(defun flymake-haskell-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-dir   (file-name-directory buffer-file-name))
         (local-file  (file-relative-name
                       temp-file
                       local-dir)))
    (list "~/.emacs.d/bin/flycheck_haskell.pl" (list local-file local-dir))))

(push '(".+\\hs$" flymake-haskell-init) flymake-allowed-file-name-masks)
(push '(".+\\lhs$" flymake-haskell-init) flymake-allowed-file-name-masks)
(push
 '("^\\(\.+\.hs\\|\.lhs\\):\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)"
   1 2 3 4) flymake-err-line-patterns)

(add-hook 'haskell-mode-hook
          '(lambda ()
             (if (not (null buffer-file-name)) (flymake-mode))
          ))

;; PHP
(when (not (fboundp 'flymake-php-init))
  ;; flymake-php-initが未定義のバージョンだったら、自分で定義する
  (defun flymake-php-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                         (quote flymake-create-temp-inplace)))
           (local-file  (file-relative-name
                         temp-file
                         (file-name-directory buffer-file-name))))
      (list "php" (list "-f" local-file "-l"))))
  (setq flymake-allowed-file-name-masks
        (append
         flymake-allowed-file-name-masks
         (quote (("\\.php[345]?$" flymake-php-init)))))
  (setq flymake-err-line-patterns
        (cons
         (quote ("\\(\\(?:Parse error\\|Fatal error\\|Warning\\): .*\\) in \\(.*\\) on line \\([0-9]+\\)" 2 3 nil 1))
	 flymake-err-line-patterns)))
(add-hook (quote php-mode-hook)
	  (quote (lambda() (flymake-mode t))))

;;; html
(defun flymake-html-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "tidy" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html$\\|\\.ctp" flymake-html-init))

(add-to-list 'flymake-err-line-patterns
             '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
               nil 1 2 4))
(add-hook 'nxml-mode-hook 'flymake-mode)

;; JavaScript用設定
(when (not (fboundp (quote flymake-javascript-init)))
  ;; flymake-javascript-initが未定義のバージョンだったら、自分で定義する
  (defun flymake-javascript-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       (quote flymake-create-temp-inplace)))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      ;;(list "js" (list "-s" local-file))
      (list "jsl" (list "-process" local-file))
      ))
  (setq flymake-allowed-file-name-masks
	(append
	 flymake-allowed-file-name-masks
	 (quote (("\.json$" flymake-javascript-init)
		 ("\.js$" flymake-javascript-init)))))
  (setq flymake-err-line-patterns
	(cons
	 (quote ("\(.+\)(\([0-9]+\)): \(?:lint \)?\(\(?:warning\|SyntaxError\):.+\)" 1 2 nil 3))
	 flymake-err-line-patterns)))
(add-hook (quote javascript-mode-hook)
	  (quote (lambda() (flymake-mode t))))

;;; emacs lisp エラーが出るからコメントアウト
;; (defun flymake-elisp-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "elisplint" (list local-file))))
;; (push '("\\.el$" flymake-elisp-init) flymake-allowed-file-name-masks)
;; (add-hook 'emacs-lisp-mode-hook 'flymake-mode)

;;; Perl
;; http://unknownplace.org/memo/2007/12/21#e001
;; (defvar flymake-perl-err-line-patterns
;;   '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

;; (defconst flymake-allowed-perl-file-name-masks
;;   '(("\\.pl$" flymake-perl-init)
;;     ("\\.pm$" flymake-perl-init)
;;     ("\\.t$" flymake-perl-init)))

;; (defun flymake-perl-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "perl" (list "-wc" local-file))))

;; (defun flymake-perl-load ()
;;   (interactive)
;;   (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;;     (setq flymake-check-was-interrupted t))
;;   (ad-activate 'flymake-post-syntax-check)
;;   (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
;;   (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
;;   (set-perl5lib)
;;   (flymake-mode t))

;; (add-hook 'cperl-mode-hook 'flymake-perl-load)


;; ;;; fuzzy pair
;; (defun flymake-fuzzy-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "fuzzylint" (list local-file))))
;; (push '("\\.ctp$" flymake-fuzzy-init) flymake-allowed-file-name-masks)

;; ;;(add-hook 'nxml-mode-hook 'flymake-mode)

;; ;;; Ruby
;; ;; Invoke ruby with '-c' to get syntax checking
;; (defun flymake-ruby-init ()
;;   (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;          (local-file  (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "ruby" (list "-c" local-file))))
;; (push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
;; (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
;; (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

;; (add-hook 'ruby-mode-hook '(lambda ()
;;                              ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
;;                              (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
;;                                  (flymake-mode))))

;;http://www.credmp.org/2007/07/20/on-the-fly-syntax-checking-java-in-emacs/
;; (defun credmp/flymake-display-err-minibuf ()
;;   "Displays the error/warning for the current line in the minibuffer"
;;   (interactive)
;;   (let* ((line-no (flymake-current-line-no))
;;          (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
;;          (count (length line-err-info-list))
;;          )
;;     (while (> count 0)
;;       (when line-err-info-list
;;         (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
;;                (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
;;                (text (flymake-ler-text (nth (1- count) line-err-info-list)))
;;                (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
;;           (message "[%s] %s" line text)
;;           )
;;         )
;;       (setq count (1- count)))))


;; (defun next-flymake-error ()
;;   (interactive)
;;   (flymake-goto-next-error)
;;   (let ((err (get-char-property (point) 'help-echo)))
;;     (when err
;;       (message err))))
;; (global-set-key "\C-c e" 'next-flymake-error)


;; ;; when buffer-file-name is nil.
;; (defadvice flymake-mode (around check-buffer-file-name-exists activate)
;;   (when buffer-file-name
;;     ad-do-it))




;; #### glowl 通知　激遅
;; (setq flymake-growl-warning-priority 1)
;; (setq flymake-growl-error-priority   2)

;; (setq flymake-growl-warning-sticky t)
;; (setq flymake-growl-error-sticky   t)

;; (setq flymake-growl-sticky-list nil)

;; (defun flymake-growl-notify (file line-no message priority sticky)
;;   (let* ((title (concat file ":" (int-to-string line-no) ":"))
;;         (command (concat "growlnotify --appIcon  Emacs"
;;                                     " --progress 0.1"
;;                                     " --title \""  title "\""
;;                                     " --identifier \"" title "\""
;;                                     " --message \"" message "\""
;;                                     " --priority " (int-to-string priority))))
;;     (shell-command (concat command (if sticky " --sticky")))
;;     (if sticky (add-to-list 'flymake-growl-sticky-list (list file line-no message priority)))))

;; (defun flymake-growl-delete-notify (buffer-name)
;;   (interactive "b")
;;   (let ((sticky-list flymake-growl-sticky-list))
;;     (setq flymake-growl-sticky-list nil)
;;     (mapc (lambda (sticky)
;;             (if (string= buffer-name (car sticky))
;;                 (apply 'flymake-growl-notify (append sticky '(nil)))
;;               (add-to-list 'flymake-growl-sticky-list sticky)))
;;           sticky-list)))

;; (defun flymake-growl-delete-all-notify ()
;;   (interactive)
;;   (mapc (lambda (sticky)
;;           (apply 'flymake-growl-notify (append sticky '(nil))))
;;         flymake-growl-sticky-list)
;;   (setq flymake-growl-sticky-list nil))

;; (defun flymake-growl-rename-notify (old-name new-name)
;;   (mapc (lambda (sticky)
;;           (when (string= old-name (car sticky))
;;             (flymake-growl-delete-notify old-name)
;;             (flymake-growl-notify new-name
;;                                   (nth 1 sticky)
;;                                   (nth 2 sticky)
;;                                   (nth 3 sticky)
;;                                   t)))
;;         flymake-growl-sticky-list))

;; (defadvice flymake-make-overlay (after flymake-growl-make-overlay activate)
;;   (let* ((face (ad-get-arg 3))
;;          (priority (case face
;;                      ('flymake-warnline flymake-growl-warning-priority)
;;                      ('flymake-errline  flymake-growl-error-priority)
;;                      (t 0)))
;;          (sticky (case face
;;                    ('flymake-warnline flymake-growl-warning-sticky)
;;                    ('flymake-errline flymake-growl-error-sticky)
;;                    (t nil))))
;;     (flymake-growl-notify (buffer-name) line-no (ad-get-arg 2) priority sticky)))

;; (defadvice flymake-delete-own-overlays (after flymake-growl-delete-own-overlays activate)
;;   (flymake-growl-delete-notify (buffer-name)))

;; (defadvice kill-buffer (before flymake-growl-kill-buffer activate)
;;   (flymake-growl-delete-notify (buffer-name)))

;; (add-hook 'kill-emacs-hook 'flymake-growl-delete-all-notify)

;; (defadvice rename-buffer (around flymake-growl-rename-buffer activate)
;;   (let ((old-name (buffer-name))
;;         new-name)
;;     ad-do-it
;;     (setq new-name (buffer-name))
;;     (flymake-growl-rename-notify old-name new-name)))


;; エラーメッセージをポップアップ表示
(global-set-key "\M-e" 'flymake-goto-next-error)
(global-set-key "\M-E" 'flymake-goto-prev-error)

;; gotoした際にエラーメッセージをminibufferに表示する
(defun display-error-message ()
  (message (get-char-property (point) 'help-echo)))
(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
  (display-error-message))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
  (display-error-message))
(ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
(ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)