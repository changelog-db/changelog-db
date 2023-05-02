;; -*- mode: lisp-interaction; lexical-binding: t; -*-
(defun ChangelogDB:markdown ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^Last updated: \\(.*\\)" nil t)
      (replace-match (format-time-string "%FT%T%z") nil nil nil 1))))
(defun ChangelogDB:yaml ()
  (when (file-exists-p "README.md")
    (with-temp-file "README.md"
      (insert-file-contents "README.md")
      (ChangelogDB:markdown)))
  (let ((old-point (point)))
    (goto-char (point-min))
    (when (eql ?\n (char-after))
      (delete-char 1))
    (while (search-forward "\n\n" nil t)
      (replace-match "\n"))
    (sort-lines nil (point-min) (point-max))
    (goto-char old-point)))

(defun ChangelogDB:dev-setup ()
  (pcase major-mode
    ('yaml-mode
     (add-hook 'before-save-hook #'ChangelogDB:yaml nil t))
    ('markdown-mode
     (add-hook 'before-save-hook #'ChangelogDB:markdown nil t))))
