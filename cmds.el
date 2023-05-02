;; -*- mode: lisp-interaction; lexical-binding: t; -*-
(require 'dash)
(require 'f)
(require 'json)
(defun ChangelogDB:markdown ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^Last updated: \\(.*\\)" nil t)
      (replace-match (format-time-string "%FT%T%z") nil nil nil 1))))
(defun ChangelogDB:insert-folder (dir url)
  "Insert entries for DIR, a folder of packages."
  (interactive
   (list (read-directory-name "Local folder of packages: ")
         (read-string "Remote path of packages: ")))
  (--each (f-directories dir)
    (when (and (f-exists? (f-join it "package.json"))
               (f-exists? (f-join it "CHANGELOG.md")))
      (let ((data (json-read-file (f-join it "package.json"))))
        (let-alist data
          (unless .private
            (insert (format "\"%s\": \"%s/%s\"\n"
                            .name
                            (f-slash url)
                            (f-join (f-base it) "CHANGELOG.md")))))))))
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
