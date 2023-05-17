;; -*- mode: lisp-interaction; lexical-binding: t; -*-

(require 'dash)
(require 'f)
(require 'json)
(require 's)
(require 'git)

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
  (ChangelogDB:with-file "changelog-db.yaml"
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
(defun ChangelogDB:yaml ()
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
        (while (re-search-forward "\\(tree\\|blob\\)/\\(master\\|main\\|HEAD\\)" nil t)
          (cl-incf count)
          (replace-match "blob" nil nil nil 1)
          (replace-match "-" nil nil nil 2))
        (when (> count 0)
          (message "Replaced %s blob/(master|main) mentions" count))))
    (let ((current-line (buffer-substring-no-properties
                         (line-beginning-position)
                         (line-end-position))))
      (sort-lines nil (point-min) (point-max))
      (delete-duplicate-lines (point-min) (point-max))
      (or (progn
            (goto-char (point-min))
            (search-forward current-line nil t))
          (goto-char old-point)))))
(defun ChangelogDB:add-template (pkgs url-template)
  "Add entries for PKGS, which is comma-separated.
Each of PKGS will be associated with URL-TEMPLATE, with its name
substituded in with `format'."
  (interactive
   (list (read-string "Packages (space-separated): ")
         (read-string "URL Template (%s stands for the package's name): ")))
  (setq url-template (string-trim url-template))
  (ChangelogDB:with-file "changelog-db.yaml"
    (dolist (pkg (split-string pkgs " " t))
      (setq pkg (string-trim pkg))
      (goto-char (point-max))
      (insert
       (if (equal url-template "")
           (format "\"%s\": false" pkg)
         (format "\"%s\": \"%s\"\n"
                 pkg (format url-template pkg)))))))
(defun ChangelogDB:add (pkg url)
  (interactive
   (let ((pkg (read-string "Package (space-separated): ")))
     (list pkg
           (read-string (format "Changelog URL for %s: " pkg)))))
  (setq pkg (->> pkg
                 (s-replace "https://npmjs.com/package/" "")
                 string-trim))
  (dolist (pkg (split-string pkg " " t))
    (setq pkg (string-trim pkg))
    (ChangelogDB:with-file "changelog-db.yaml"
      (goto-char (point-min))
      (when (re-search-forward (format "^\"%s\"" pkg) nil t)
        (user-error "%s is already present" pkg))
      (goto-char (point-max))
      (insert
       (if (equal url "")
           (format "\"%s\": false" pkg)
         (format "\"%s\": \"%s\"" pkg url))))))

(defun ChangelogDB:clone (url)
  "Git clone URL so that we can run `ChangelogDB:add-folder' on it."
  (interactive "MURL: ")
  (let ((git-repo temporary-file-directory))
    (git-run "clone" "--depth" "1" url)))

(defun ChangelogDB:dev-setup ()
  (pcase major-mode
    ('yaml-mode
     (add-hook 'before-save-hook #'ChangelogDB:yaml nil t))))
