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
 '(default ((t (:family "Fira Mono" :foundry "unknown" :slant normal :weight normal :height 90 :width normal)))))

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
(desktop-save-mode 1)

(setq sr-speedbar-right-side nil)
(setq sr-speedbar-max-width 40)
(setq sr-speedbar-width-x 30)

(global-set-key (kbd "C-<up>")    'windmove-up)
(global-set-key (kbd "C-<down>")  'windmove-down)
(global-set-key (kbd "C-<left>")  'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)
(global-set-key (kbd "C-c #")     'local-open-root)
(global-set-key (kbd "C-c $")     'local-eval-root)

(defun local-open-root ()
  "open dotfile"
  (interactive) (load-file "~/.emacs") (message "Use C-c $ to reload your config file."))

(defun local-eval-root ()
  "eval dotfile"
  (interactive)
  (eval-buffer))

(defun short-1 ()
  "doc string"
  (interactive)
  (previous-line)
  (end-of-line)
  (newline-and-indent))

(add-hook 'c-mode-common-hook (lambda ()
								(when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
								  (ggtags-mode 1)
								  (global-set-key (kbd "C-o") 'short-1)
								  (global-set-key (kbd "<C-tab>") 'ff-find-other-file)
								  (global-set-key (kbd "RET") 'newline-and-indent)
								  (global-set-key (kbd "C-j") 'newline)
								  (global-set-key (kbd "M-g d") 'ggtags-find-definition)
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


(provide '.emacs)
;;; .emacs ends here
