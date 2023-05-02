;; -*- mode: lisp-interaction; lexical-binding: t; -*-
(defun ChangelogDB:markdown ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^Last updated: \\(.*\\)" nil t)
      (replace-match (format-time-string "%FT%T%z") nil nil nil 1))))
(defun ChangelogDB:yaml ()
  (when (file-exists-p "README.md")
    (with-current-buffer (find-file-noselect "README.md")
      (ChangelogDB:markdown)))
  (let ((old-point (point)))
    (save-excursion
      (goto-char (point-min))
      (when (eql ?\n (char-after))
        (delete-char 1)))
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "\n\n" nil t)
        (replace-match "\n")))
    (save-excursion
      (goto-char (point-min))
      (let ((count 0))
        (while (re-search-forward "blob/\\(master\\|main\\)" nil t)
          (cl-incf count)
          (replace-match "-" nil nil nil 1))
        (when (> count 0)
          (message "Replaced %s blob/(master|main) mentions" count))))
    (sort-lines nil (point-min) (point-max))
    (goto-char old-point)))

(defun ChangelogDB:dev-setup ()
  (pcase major-mode
    ('yaml-mode
     (add-hook 'before-save-hook #'ChangelogDB:yaml nil t))
    ('markdown-mode
     (add-hook 'before-save-hook #'ChangelogDB:markdown nil t))))
