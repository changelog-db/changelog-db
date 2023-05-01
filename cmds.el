;; -*- mode: lisp-interaction; lexical-binding: t; -*-
(defun ChangelogDB:sort ()
  (save-excursion
    (goto-char (point-min))
    (when (eql ?\n (char-after))
      (delete-char 1))
    (while (search-forward "\n\n" nil t)
      (replace-match "\n"))
    (sort-lines nil (point-min) (point-max))))

(defun ChangelogDB:dev-setup ()
  (add-hook 'before-save-hook #'ChangelogDB:sort nil t))
