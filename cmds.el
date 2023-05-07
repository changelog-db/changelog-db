;; -*- mode: lisp-interaction; lexical-binding: t; -*-
(require 'dash)
(require 'f)
(require 'json)
(defmacro ChangelogDB:with-file (file &rest body)
  (declare (indent 1))
  (let ((here (-some-> (or load-file-name buffer-file-name)
                file-name-directory)))
    `(let ((default-directory ,here))
       (when (file-exists-p ,file)
         (with-current-buffer (find-file-noselect ,file)
           ,@body
           (basic-save-buffer))))))
(defun ChangelogDB:markdown ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^Last updated: \\(.*\\)" nil t)
      (replace-match (format-time-string "%FT%T%z") nil nil nil 1))))
(defun ChangelogDB:add-folder (dir url same-one?)
  "Insert entries for DIR, a folder of packages."
  (interactive
   (let ((same-one? (y-or-n-p "Do the packages share the same changelog URL? ")))
     (list (read-directory-name "Local folder of packages: ")
           (read-string (if same-one?
                            "Changelog URL: "
                          "Remote path of packages: "))
           same-one?)))
  (ChangelogDB:with-file "changelog-db.yaml"
    (goto-char (point-max))
    (--each (f-directories dir)
      (when (and (f-exists? (f-join it "package.json"))
                 (or same-one? (f-exists? (f-join it "CHANGELOG.md"))))
        (let ((data (json-read-file (f-join it "package.json"))))
          (let-alist data
            (unless .private
              (insert
               (if same-one?
                   (format "\"%s\": \"%s\"\n" .name url)
                 (format "\"%s\": \"%s/%s\"\n"
                         .name
                         (f-slash url)
                         (f-join (f-base it) "CHANGELOG.md")))))))))))
(defun ChangelogDB:yaml ()
  (ChangelogDB:with-file "README.md"
    (ChangelogDB:markdown))
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
    (delete-duplicate-lines (point-min) (point-max))
    (goto-char old-point)))
(defun ChangelogDB:add (pkg url)
  (interactive "MPackage: \nMURL: ")
  (ChangelogDB:with-file "changelog-db.yaml"
    (goto-char (point-max))
    (insert (format "\"%s\": \"%s\"" pkg url))))

(defun ChangelogDB:dev-setup ()
  (pcase major-mode
    ('yaml-mode
     (add-hook 'before-save-hook #'ChangelogDB:yaml nil t))
    ('markdown-mode
     (add-hook 'before-save-hook #'ChangelogDB:markdown nil t))))
