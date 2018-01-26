;; Add Repositories
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
         '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)

;; Load An's favorite theme
(add-to-list 'load-path "~/.emacs.d/themes/elisp")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;;(load-theme ' t)

;; Startup Config for MSWindows
(defun toggle-full-screen () (interactive) (shell-command "emacs_fullscreen.exe"))
(global-set-key [f11] 'toggle-full-screen)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
;;(menu-bar-mode -1)
;;(tool-bar-mode -1)
;;(scroll-bar-mode -1)

;;;;------------------------------------------------------------------------
;; An empirical code segment to help emacs on cygwin with theme
;;(defun on-after-init ()
;;  (unless (display-graphic-p (selected-frame))
;;    (set-face-background 'default "unspecified-bg" (selected-frame))))
;;(add-hook 'window-setup-hook 'on-after-init)
;;;;------------------------------------------------------------------------

(show-paren-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-names-vector
   ["#110F13" "#B13120" "#719F34" "#CEAE3E" "#7C9FC9" "#7868B5" "#009090" "#F4EAD5"])
 '(fci-rule-character-color "#202020")
 '(fci-rule-color "#202020")
 '(frame-brackground-mode (quote dark))
 '(fringe-mode 4 nil (fringe))
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(package-selected-packages
   (quote
    (latex-preview-pane cdlatex color-theme-sanityinc-tomorrow rainbow-delimiters ## auctex)))
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(vc-annotate-background "#1f2124")
 '(vc-annotate-color-map
   (quote
    ((20 . "#ff0000")
     (40 . "#ff4a52")
     (60 . "#f6aa11")
     (80 . "#f1e94b")
     (100 . "#f5f080")
     (120 . "#f6f080")
     (140 . "#41a83e")
     (160 . "#40b83e")
     (180 . "#b6d877")
     (200 . "#b7d877")
     (220 . "#b8d977")
     (240 . "#b9d977")
     (260 . "#93e0e3")
     (280 . "#72aaca")
     (300 . "#8996a8")
     (320 . "#afc4db")
     (340 . "#cfe2f2")
     (360 . "#dc8cc3"))))
 '(vc-annotate-very-old-color "#dc8cc3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; AUCTeX Config
(load "auctex.el" nil t t)
(require 'latex)
(require 'tex-site)
(require 'tex-mik)
(defun auctex-theme()
  (when (window-system)
    (load-theme 'sanityinc-tomorrow-eighties t)
    (set-frame-font "Palatino Linotype" t nil)
    (set-face-attribute 'default (selected-frame) :height 110)))
(add-hook 'TeX-mode-hook 'auctex-theme)
(add-hook 'TeX-mode-hook #'rainbow-delimiters-mode)
(add-hook 'TeX-mode-hook (lambda () (TeX-fold-mode 1)))

;; Set the default PDF reader to SumatraPDF. The executable should be in PATH
(setq TeX-view-style (quote (("^epsf$" "SumatraPDF.exe %f") ("." "yap -1 %dS %d"))))
 
(setq TeX-output-view-style 
      (quote 
       (("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "dvips %d -o && start %f") 
        ("^dvi$" "." "yap -1 %dS %d") 
        ("^pdf$" "." "SumatraPDF.exe -reuse-instance %o") 
        ("^html?$" "." "start %o"))))

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(setq-default TeX-PDF-mode t)

(add-to-list 'LaTeX-indent-environment-list '("tikzpicture"))
(add-to-list 'LaTeX-verbatim-environments "comment")

;; Specify LateX Config
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'latex-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;; cdlatex Config
;;(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
;;(add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode
;;latexmk
(defun run-latexmk ()
  (interactive)
  (let ((TeX-save-query nil)
        (TeX-process-asynchronous nil)
        (master-file (TeX-master-file)))
    (TeX-save-document "")
    (TeX-run-TeX "latexmk"
                 (TeX-command-expand "latexmk %t" 'TeX-master-file)
                 master-file)
    (if (plist-get TeX-error-report-switches (intern master-file))
        (TeX-next-error t)
      (minibuffer-message "latexmk done"))))
