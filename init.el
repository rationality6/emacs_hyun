;; 한글 세팅
(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
;; S-spacebar 에 단축키 배정
(global-set-key (kbd "<S-kana>") 'toggle-input-method)
;; 메뉴바 삭제
(menu-bar-mode -1)
;; 툴바 삭제
(tool-bar-mode 0)
;; 스크롤바 삭제
(toggle-scroll-bar -1)
;; 초기화면 Load 하지말기
(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
;; 하이라이트 matching paren
(show-paren-mode 1)
;; 자동 브라켓 닫아주기
(electric-pair-mode t)
;; 프리즈 기능 제거 C-z
(global-unset-key (kbd "C-z"))
;; "yes/no" === "y/n"
(fset 'yes-or-no-p 'y-or-n-p)
;; 백업파일 제거
(setq make-backup-files nil)

;; Function name at point in mode line
(which-function-mode t)
;; Highlight selection between point and mark
(transient-mark-mode t)
;; Syntax highlighting
(global-font-lock-mode t)
;; Move by camelCase words
(global-subword-mode t)
;; Don't insert instructions in the *scratch* buffer
(setq initial-scratch-message nil)
;; Show line-number
(line-number-mode 1)

;; 왜 작동을 안하니
;; Auto-start on any markup modes
;; (add-hook 'sgml-mode-hook 'emmet-mode)

;; Compile When Init.el Modified
(defun autocompile nil
  (interactive)
  (require 'bytecomp)
  (let ((initemacs (expand-file-name "~/.emacs.d/init.el")))
    (if (string= (buffer-file-name) (file-chase-links initemacs))
        (byte-compile-file initemacs))))
(add-hook 'after-save-hook 'autocompile)

;; Smooth-scrolling Fix
(setq scroll-conservatively 101)
(setq mouse-wheel-scroll-amount '(1))
(setq mouse-wheel-progressive-speed nil)

;; MELPA
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; El-Get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.org/packages/"))
  (package-refresh-contents)
  (package-initialize)
  (package-install 'el-get)
  (require 'el-get))
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;; Install Use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Get Packages
(require 'use-package)
(use-package clojure-mode :ensure clojure-mode)
(use-package color-theme :ensure color-theme)
(use-package projectile :ensure projectile)
(use-package helm :ensure helm)
(use-package helm-projectile :ensure helm-projectile)
(use-package paredit :ensure paredit)
(use-package undo-tree :ensure undo-tree)
(use-package highlight-parentheses :ensure highlight-parentheses)
(use-package lispy :ensure lispy)
(use-package oceanic-theme :ensure oceanic-theme)
(use-package expand-region :ensure expand-region)
(use-package web-mode :ensure web-mode)
(use-package css-mode :ensure css-mode)
(use-package bind-key :ensure bind-key)
(use-package haskell-mode  :ensure haskell-mode)
(use-package clj-refactor :ensure clj-refactor)
(use-package lua-mode :ensure lua-mode)
(use-package scss-mode :ensure scss-mode)
(use-package rust-mode :ensure rust-mode)
(use-package cargo :ensure cargo)
(use-package flycheck :ensure flycheck :init (global-flycheck-mode))
(use-package flycheck-rust :ensure flycheck-rust)
(use-package racer :ensure racer)
(use-package company :ensure company)
(use-package company-web :ensure company-web)
(use-package highlight-symbol :ensure highlight-symbol)
(use-package vue-mode :ensure vue-mode)
(use-package json-mode :ensure json-mode)
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
(use-package exec-path-from-shell :ensure exec-path-from-shell)
(use-package rvm :ensure rvm)

;; Undo-tree
(global-undo-tree-mode)

;; Lispy
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'clojure-mode-hook (lambda () (lispy-mode 1)))

;; Expand Region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-style-padding 2)
(setq web-mode-script-padding 2)
(setq web-mode-enable-auto-pairing t)
(setq web-mode-enable-css-colorization t)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; Improved JSX syntax-highlighting in web-mode
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

;; Disable jshint
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; Customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; Css-mode
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(autoload 'css-mode "css-mode" nil t)

;; Indentation
(defun my-setup-indent (n)
  (setq javascript-indent-level n)
  (setq js-indent-level n)
  (setq web-mode-markup-indent-offset n)
  (setq web-mode-css-indent-offset n)
  (setq web-mode-code-indent-offset n)
  (setq css-indent-offset n)
  (setq indent-tabs-mode nil)
  (setq-default indent-tabs-mode nil)
  (setq web-mode-attr-indent-offset nil))
(my-setup-indent 2)

;; Text-mode Indentation (2 spaces)
(add-hook 'text-mode-hook
          '(lambda ()
             (setq indent-tabs-mode nil)
             (setq tab-width 2)))

;; Highlight Parens
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda () (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; Helm
(require 'helm-config)
(helm-mode 1)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z")  'helm-select-action)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "M-p") 'ace-window)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x c o") 'helm-occur)
(global-set-key (kbd "C-c f") 'helm-recentf)
(setq helm-truncate-lines 1)

;; Projectile
(projectile-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-switch-project-action 'helm-projectile)

;; HideShow
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "C-c C-h") 'hs-hide-all)
(global-set-key (kbd "C-c C-s") 'hs-show-all)

;; Company
(global-company-mode)
(setq company-tooltip-align-annotations t)
(setq company-idle-delay .3)
(setq company-begin-commands '(self-insert-command))
(add-to-list 'company-dabbrev-code-modes 'web-mode)
(define-key company-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;; Clojure
(add-hook 'clojure-mode-hook 'cider-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-repl-mode-hook #'lispy-mode)
(global-set-key [f9] 'cider-jack-in)
(require 'clj-refactor)
(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m"))
(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)
(setq cider-repl-use-pretty-printing t)
(defun figwheel-cljs-repl ()
  (interactive
   (cider-interactive-eval
    "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")))

;; Highlight Symbol
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;; SCSS-mode
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; Haskell
(eval-after-load "haskell-mode"
  '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))

;; Rust
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(setq racer-cmd (expand-file-name "~/.cargo/bin/racer"))
(setq racer-rust-src-path (file-truename "~/rustc-1.13.0/src"))
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

;; Load PATH Variables in OSX
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; rvm
(rvm-use-default)

;; SuperCollider
;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/SuperCollider")
;; (require 'sclang)

;; Tidal
;; (add-to-list 'load-path "~/tidal")
;; (require 'tidal)

;; Recompile
;; (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)

;; Theme Config
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (oceanic)))
 '(linum-format " %5i ")
 '(package-selected-packages
   (quote
    (rvm robe markdown-mode json-mode vue-mode highlight-symbol company-web company racer flycheck-rust flycheck cargo rust-mode scss-mode lua-mode clj-refactor haskell-mode web-mode expand-region oceanic-theme lispy highlight-parentheses undo-tree paredit helm-projectile helm projectile color-theme clojure-mode use-package el-get))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
