;; Installed packages:
;; fiplr
;; auto-complete-clang
;; yasnippet
;; sr-speedbar
;; ido
;; ggtags
;; flycheck
;; TODO ibuffer

(defun s-trim-left (s) ""
  (if (string-match "\\`[ \t\n\r]+" s)
	  (replace-match "" t t s)
	s))

(defun s-trim-right (s) ""
  (if (string-match "[ \t\n\r]+\\'" s)
	  (replace-match "" t t s)
	s))

(defun s-trim (s) ""
  (s-trim-left (s-trim-right s)))

(defun local-delete-line ()
  "deletes 1 line"
  (interactive)
  (beginning-of-line)
  (let ((beg (point)))
	(next-line)
	(beginning-of-line)
	(delete-region beg (point))))

(defun short-1 ()
  "doc string"
  (interactive)
  (previous-line)
  (end-of-line)
  (newline-and-indent))

(defun scroll-up-keep-cursor ()
  "scrolls up without cursor"
  (interactive)
  (scroll-up 1))

(defun scroll-down-keep-cursor ()
  "scrolls down without cursor"
  (interactive)
  (scroll-down 1))

(defun gtags-root-dir ()
  "Get root dir"
  (with-temp-buffer
	(if (zerop (call-process "global" nil t nil "-pr"))
		(buffer-substring (point-min) (1- (point-max)))
	  nil)))

(defun gtags-update ()
  "update gtags"
  (call-process "global" nil nil nil "-u"))

(defun gtags-update-hook ()
  (when (gtags-root-dir)
	(progn
	  (gtags-update))))

;; System-specific settings

(defun is-windows () "" (if (string-equal system-type "windows-nt") t nil))
(defun is-linux   () "" (if (string-equal system-type "gnu/linux")  t nil))
(defun is-osx     () "" (if (string-equal system-type "darwin")     t nil))

(setq cur-hostname (s-trim (shell-command-to-string "hostname")))

(when (is-linux)
  (custom-set-faces '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 120 :width normal))))))

(when (is-windows)
  (custom-set-faces '(default ((t (:family "Liberation Mono" :foundry "unknown" :slant normal :weight normal :height 140 :width normal))))))

;; OSX todo: revert Home/End keybindings to *normal* behavior.
(when (is-osx)
  (custom-set-faces '(default ((t (:family "Menlo" :foundry "unknown" :slant normal :weight normal :height 140 :width normal))))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(require 'yasnippet)
(require 'auto-complete-clang)
(require 'ido)
(require 'sr-speedbar)

(tool-bar-mode 0)
(menu-bar-mode 0)
(ido-mode t)
(setq ac-quick-help-delay 0.1)
(setq default-tab-width 4)
(setq speedbar-use-images nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(yas-global-mode 1)
(setq sr-speedbar-right-side nil)
(setq sr-speedbar-max-width 40)
(setq sr-speedbar-width-x 30)
(custom-set-variables
 '(custom-enabled-themes (quote (misterioso)))
 '(ido-enable-flex-matching t)
 '(inhibit-startup-screen t))

(global-set-key (kbd "C-<up>") 'windmove-up)
(global-set-key (kbd "C-<down>") 'windmove-down)
(global-set-key (kbd "C-<left>") 'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)

(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-o") 'other-window)
(add-hook 'dired-mode-hook (lambda () (define-key dired-mode-map (kbd "M-o") 'other-window)))
(add-hook 'ibuffer-mode-hook (lambda () (define-key ibuffer-mode-map (kbd "M-o") 'other-window)))
(global-unset-key (kbd "C-x o"))
(global-unset-key (kbd "C-x 0"))
(global-unset-key (kbd "C-x 1"))
(global-unset-key (kbd "C-x 2"))
(global-unset-key (kbd "C-x 3"))

(global-set-key (kbd "C-'") 'match-paren)
(global-set-key (kbd "M-k") 'kill-buffer)

(global-set-key (kbd "C-S-<down>") 'scroll-up-keep-cursor)
(global-set-key (kbd "C-S-<up>") 'scroll-down-keep-cursor)
(global-set-key (kbd "C-d") 'local-delete-line)
(global-set-key (kbd "M-g d") 'ggtags-find-definition)
(global-set-key (kbd "M-g f") 'fiplr-find-file)
(global-set-key (kbd "C-<delete>") 'kill-region)
(global-set-key (kbd "C-j") 'newline)
(global-set-key (kbd "RET") 'newline-and-indent)

(defun custom-ruby-mode-hook ()
  (auto-complete-mode 1)
  (linum-mode 1)
  (global-set-key (kbd "C-o") 'short-1)
  (global-set-key (kbd "C-x /") 'comment-region)
  (setq ruby-indent-level 4))

(defun custom-python-mode-hook ()
  (linum-mode 1)
  (global-set-key (kbd "C-o") 'short-1)
  (global-set-key (kbd "C-x /") 'comment-or-uncomment-region)
  (auto-complete-mode 1))

(defun custom-c-mode-hook ()
  (ggtags-mode 1)
  (auto-complete-mode 1)
  (flycheck-mode 1)
  (linum-mode 1)
  (setq c-basic-offset 4)
  (ac-set-trigger-key "TAB")
  (ac-set-trigger-key "<tab>")
  (global-set-key (kbd "C-o") 'short-1)
  (global-set-key (kbd "<C-tab>") 'ff-find-other-file)
  (global-set-key (kbd "C-.") `ac-complete-clang))
  (global-set-key (kbd "C-x /") 'comment-or-uncomment-region)

(defun custom-lisp-mode-hook () 
  (setq indent-tabs-mode nil) ;; Use spaces instead of tabs.
  (global-set-key (kbd "RET") 'newline-and-indent)
  (global-set-key (kbd "C-x /") 'comment-or-uncomment-region)
  (eldoc-mode 1)
  (linum-mode 1))

(add-hook 'after-save-hook #'gtags-update-hook)
(add-hook 'emacs-lisp-mode-hook 'custom-lisp-mode-hook)
(add-hook 'c-mode-common-hook 'custom-c-mode-hook)
(add-hook 'ruby-mode-hook 'custom-ruby-mode-hook)
(add-hook 'python-mode-hook 'custom-python-mode-hook)

(if (or (string-equal cur-hostname "hydra") (string-equal cur-hostname "succubus"))
	(setq ac-clang-flags
		  (split-string
"-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/../../../../include/c++/4.9.0
-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/../../../../include/c++/4.9.0/x86_64-unknown-linux-gnu
-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/../../../../include/c++/4.9.0/backward
-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/include
-I/usr/local/include
-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/include-fixed
-I/usr/include
-I/home/antek/workspace/hexeditor/lib/sigcpp/libsigc++-2.3.1
-I/home/antek/workspace/hexeditor/lib/sigcpp/libsigc++-2.3.1/MSVC_Net2010
-I/home/antek/workspace/hexeditor/lib/test/googletest-read-only/include
-I/usr/include/qt4/QtGui
-I/usr/include/qt4/QtCore
-I/home/antek/workspace/hexeditor/lib
-I/home/antek/workspace/hexeditor/lib/thirdparty/check/check-0.9.12/src
-I/home/antek/workspace/hexeditor/lib/thirdparty/check/check-0.9.12
-I/home/antek/workspace/hexeditor/lib/thirdparty/patquery/include
-I../lib
-I..
-DMOC
-DQT_NO_KEYWORDS
-DUNIX
-DLINUX
-DMD_UNIX
-DMD_LINUX
-D_UNIX
-std=c++11
")))

(provide '.emacs)
;;; .emacs ends here
