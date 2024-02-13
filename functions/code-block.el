(defun code-block (language)
  "Insert an Org source code block with the specified LANGUAGE."
  (interactive "sEnter the language for the source code block: ")
  (let ((src-block (format "#+BEGIN_SRC %s\n\n#+END_SRC" language)))
    (insert src-block)
    (forward-line -1) ; Move cursor back inside the code block
    (indent-region (line-beginning-position) (line-end-position))))

(global-set-key (kbd "C-c b") 'code-block)

(provide 'code-block)
