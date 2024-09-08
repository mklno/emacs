;; ~/.emacs.d/function/conference-image.el
(require 'dash)
(require 'swiper)
(require 's)

(defvar bjm/conference-image-dir (expand-file-name "/home/mklno/Downloads"))

(defun bjm/insert-conference-image ()
  "Insert image from conference directory, rename and add link in current file.

The file is taken from a start directory set by `bjm/conference-image-dir' and moved to the current directory, renamed and embedded at the point as an org-mode link. The user is presented with a list of files in the start directory, from which to select the file to move, sorted by most recent first."
  (interactive)
  (let (file-list target-dir file-list-sorted start-file start-file-full file-ext end-file end-file-base end-file-full file-number)
    ;; clean directories from list but keep times
    (setq file-list
          (-remove (lambda (x) (nth 1 x))
                   (directory-files-and-attributes bjm/conference-image-dir)))

    ;; get target directory
    (setq target-dir (file-name-directory (buffer-file-name)))

    ;; sort list by most recent
    (setq file-list-sorted
          (mapcar #'car
                  (sort file-list
                        #'(lambda (x y) (time-less-p (nth 6 y) (nth 6 x))))))

    ;; use ivy to select start-file
    (setq start-file (ivy-read
                      (concat "Move selected file to " target-dir ":")
                      file-list-sorted
                      :re-builder #'ivy--regex
                      :sort nil
                      :initial-input nil))

    ;; add full path to start file and end-file
    (setq start-file-full
          (expand-file-name start-file bjm/conference-image-dir))
    ;; generate target file name from current org section
    (setq file-ext ".jpg")
    ;; get section heading and clean it up
    (setq end-file-base (s-downcase (s-dashed-words (nth 4 (org-heading-components)))))
    ;; shorten to first 40 chars to avoid long file names
    (setq end-file-base (s-left 40 end-file-base))
    ;; number to append to ensure unique name
    (setq file-number 1)
    (setq end-file (concat
                    end-file-base
                    (format "-%s" file-number)
                    file-ext))

    ;; increment number at end of name if file exists
    (while (file-exists-p end-file)
      ;; increment
      (setq file-number (+ file-number 1))
      (setq end-file (concat
                      end-file-base
                      (format "-%s" file-number)
                      file-ext))
      )

    ;; final file name including path
    (setq end-file-full
          (expand-file-name end-file target-dir))
    ;; rename file
    (rename-file start-file-full end-file-full)
    (message "moved %s to %s" start-file-full end-file)
    ;; insert link
    (insert (org-make-link-string (format "file:%s" end-file)))
    ;; display image
    (org-display-inline-images t t)))

