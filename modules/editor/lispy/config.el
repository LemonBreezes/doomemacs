;;; editor/lispy/config.el -*- lexical-binding: t; -*-

(use-package! lispy
  :hook ((lisp-mode . lispy-mode)
         (emacs-lisp-mode . lispy-mode)
         (ielm-mode . lispy-mode)
         (scheme-mode . lispy-mode)
         (racket-mode . lispy-mode)
         (hy-mode . lispy-mode)
         (lfe-mode . lispy-mode)
         (dune-mode . lispy-mode)
         (clojure-mode . lispy-mode)
         (fennel-mode . lispy-mode))
  :init
  (add-hook! 'eval-expression-minibuffer-setup-hook
    (defun doom-init-lispy-in-eval-expression-h ()
      "Enable `lispy-mode' in the minibuffer for `eval-expression'."
      (lispy-mode)
      ;; When `lispy-key-theme' has `parinfer', the TAB key doesn't do
      ;; completion, neither (kbd "<tab>"/"TAB"/"C-i")/[tab]/"\C-i" works in
      ;; terminal as tested so remapping is used as a workaround
      (local-set-key (vector 'remap (lookup-key lispy-mode-map (kbd "TAB"))) #'completion-at-point)))
  :config
  (setq lispy-close-quotes-at-end-p t)
  (add-hook 'lispy-mode-hook #'turn-off-smartparens-mode)

  ;; We recommend `outline-minor-faces-mode' from
  ;; https://github.com/tarsius/outline-minor-faces as an alternative which
  ;; respects `outline-regexp' and `outline-level'.
  (setq lispy-font-lock-keywords nil)

  (when (modulep! :lang emacs-lisp)
    (add-hook 'lispy-mode-hook #'+lispy-restore-elisp-outline-settings)))


(use-package! lispyville
  :when (modulep! :editor evil)
  :hook (lispy-mode . lispyville-mode)
  :init
  (setq lispyville-key-theme
        '((operators normal)
          c-w
          (prettify insert)
          (atom-movement t)
          slurp/barf-lispy
          additional
          additional-insert))
  :config
  (lispyville-set-key-theme)
  (add-hook! 'evil-escape-inhibit-functions
    (defun +lispy-inhibit-evil-escape-fn ()
      (and lispy-mode (evil-insert-state-p)))))
