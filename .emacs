(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (misterioso)))
 '(ido-enable-flex-matching t)
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Mono" :foundry "unknown" :slant normal :weight normal :height 120 :width normal)))))

(require 'package)

;; Installed packages:
;; fiplr
;; auto-complete-clang
;; yasnippet
;; sr-speedbar
;; ido
;; ggtags
;; flycheck

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
(yas-global-mode 1)

(setq sr-speedbar-right-side nil)
(setq sr-speedbar-max-width 40)
(setq sr-speedbar-width-x 30)

(global-set-key (kbd "C-<up>")     'windmove-up)
(global-set-key (kbd "C-<down>")   'windmove-down)
(global-set-key (kbd "C-<left>")   'windmove-left)
(global-set-key (kbd "C-<right>")  'windmove-right)
(global-set-key (kbd "C-S-<down>") 'scroll-up-keep-cursor)
(global-set-key (kbd "C-S-<up>")   'scroll-down-keep-cursor)
(global-set-key (kbd "C-d")        'local-delete-line)

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

(add-hook 'c-mode-common-hook (lambda ()
								(when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
								  (ggtags-mode 1)
								  (global-set-key (kbd "C-o") 'short-1)
								  (global-set-key (kbd "<C-tab>") 'ff-find-other-file)
								  (global-set-key (kbd "RET") 'newline-and-indent)
								  (global-set-key (kbd "C-j") 'newline)
								  (global-set-key (kbd "M-g d") 'ggtags-find-definition)
								  (global-set-key (kbd "M-g f")     'fiplr-find-file)
								  (global-auto-complete-mode 1)
								  (global-flycheck-mode 1)
								  (global-linum-mode 1)
								  (ac-set-trigger-key "TAB")
								  (ac-set-trigger-key "<tab>")
								  (global-set-key (kbd "C-.") `ac-complete-clang)
								  )))

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
	(gtags-update)))

(add-hook 'after-save-hook #'gtags-update-hook)

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
"))


(provide '.emacs)
;;; .emacs ends here
