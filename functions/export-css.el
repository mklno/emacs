(defun export-css (fileName)
  "Insert an Org source code block with the specified file name."
  (interactive "sEnter the name of the file: ")
  (let ((src-block (format "#+EXPORT_FILE_NAME: ~/myNotes/%s\n#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"https://gongzhitaao.org/orgcss/org.css\"/>\n#+HTML_HEAD_EXTRA: <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/>\n" fileName)))
    (insert src-block)))

(global-set-key (kbd "C-c e") 'export-css)

(provide 'export-css)

