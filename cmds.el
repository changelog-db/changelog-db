;; -*- mode: lisp-interaction; lexical-binding: t; -*-

(require 'dash)
(require 'f)
(require 'json)
(require 's)
(require 'git)

(defvar ChangelogDB::pkg-history)
(defvar ChangelogDB::url-history)
(defmacro ChangelogDB:with-file (file &rest body)
  (declare (indent 1))
  (let ((here (-some-> (or load-file-name buffer-file-name)
                file-name-directory)))
    `(let ((default-directory ,here))
       (when (file-exists-p ,file)
         (with-current-buffer (find-file-noselect ,file)
           ,@body
           (basic-save-buffer))))))
(defun ChangelogDB:add-folder (dir url same-one?)
  "Insert entries for DIR, a folder of packages."
  (interactive
   (let ((same-one? (y-or-n-p "Do the packages share the same changelog URL? ")))
     (list (read-directory-name "Local folder of packages: ")
           (read-string (if same-one?
                            "Changelog URL: "
                          "Remote path of packages: "))
           same-one?)))
  (ChangelogDB:with-file "changelog-db.data"
    (goto-char (point-max))
    (--each (f-directories dir)
      (when (and (f-exists? (f-join it "package.json"))
                 (if same-one?
                     (not (f-exists? (f-join it "CHANGELOG.md")))
                   (f-exists? (f-join it "CHANGELOG.md"))))
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
(defun ChangelogDB:add (pkgs url)
  "Add entries from PKGS to URL.
URL can contain %s which stands for the package name."
  (interactive
   (let ((pkgs (read-string "Package (space-separated): "
                            nil 'ChangelogDB::pkg-history)))
     (list pkgs
           (completing-read (format "Changelog URL for %s: " pkgs)
                            (list "https://github.com/sindresorhus/%s/releases"
                                  "https://github.com/jshttp/%s/blob/-/HISTORY.md")
                            nil nil nil 'ChangelogDB::url-history))))
  (setq pkgs (->> pkgs
                  (s-replace "https://npmjs.com/package/" "")
                  string-trim))
  (ChangelogDB:with-file "changelog-db.data"
    (dolist (pkg (split-string pkgs " " t))
      (setq pkg (string-trim pkg))
      (goto-char (point-min))
      (when (re-search-forward (format "^\"%s\"" pkg) nil t)
        ;; Don't error, keep going
        (message "%s is already present" pkg))
      (goto-char (point-max))
      (insert
       (if (equal url "")
           (format "\"%s\": none\n" pkg)
         (format "\"%s\": \"%s\"\n"
                 pkg
                 ;; If URL doesn't have a placeholder, it's just
                 ;; returned as-is.
                 (format url pkg)))))))
(defun ChangelogDB:clone (url)
  "Git clone URL so that we can run `ChangelogDB:add-folder' on it."
  (interactive "MURL: ")
  (let ((git-repo temporary-file-directory))
    (git-run "clone" "--depth" "1" url)))

(defun ChangelogDB::sort-data ()
  "Sort the data fields.
Comment lines remain attached to their next lines.

Entries are sorted by keys only so that for plain keys, \"a\"
come before \"a-\" as expected. A naive text sort would put \"a-:
...\" before \"a: ...\" as the syntax character \":\" sorts after
\"-\"."
  (let ((inhibit-field-text-motion t)
        (inhibit-message t))
    (save-match-data
      (goto-char (point-min))
      (sort-subr
       nil
       ;; Going from the end of a record to the next record:
       ;; The next line starts a new record
       (lambda ()
         (forward-line))
       ;; Going from the start of a record to its end:
       ;; The end of the line after skipping comment lines
       (lambda ()
         (while (looking-at "^[[:space:]]*#")
           (forward-line))
         (end-of-line))
       ;; Going from the start of the record to the start of the key:
       ;; Skip comment lines.
       ;; (forward-line already stops at the beginning of line)
       (lambda ()
         (while (looking-at "^[[:space:]]*#")
           (forward-line)))
       ;; Going to end of the key from the start of the key:
       ;; The end of the line or the end of the key.
       (lambda ()
         (if (search-forward ":" (line-end-position) t)
             (forward-char -1)
           (end-of-line)))))))
(defun ChangelogDB::format-data ()
  (let ((old-point (point)))
    ;; Remove leading newline
    (save-excursion
      (goto-char (point-min))
      (when (eql ?\n (char-after))
        (delete-char 1)))
    ;; Remove duplicate newlines
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "\n\n" nil t)
        (replace-match "\n")))
    ;; Replace default branch names
    (save-excursion
      (goto-char (point-min))
      (let ((count 0))
        (while (re-search-forward
                (rx (group (or "tree" "blob"))
                    "/"
                    (group (or "master" "main" "HEAD")))
                nil t)
          (cl-incf count)
          (replace-match "blob" nil nil nil 1)
          (replace-match "-" nil nil nil 2))
        (when (> count 0)
          (message "Replaced %s blob/(master|main) mentions" count))))
    ;; The next block would be useless if we're at the final newline,
    ;; so back out of there.
    (when (and (eobp) (eql (char-before) ?\n))
      (forward-line -1))
    ;; Try to stay on the same text
    (let ((current-line (buffer-substring-no-properties
                         (line-beginning-position)
                         (line-end-position))))
      (ChangelogDB::sort-data)
      (delete-duplicate-lines (point-min) (point-max))
      (goto-char (point-min))
      (or (prog1 (search-forward current-line nil t)
            (beginning-of-line))
          (goto-char old-point)))))
(defun ChangelogDB:dev-setup ()
  (pcase major-mode
    ('yaml-mode
     (add-hook 'before-save-hook #'ChangelogDB::format-data nil t)
     (when (fboundp 'apheleia-mode)
       (funcall #'apheleia-mode -1)))))
