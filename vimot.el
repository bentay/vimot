;;; vimot.el --- VI-style motion when called up, but only then
;;-------------------------------------------------------------------
;;
;; Copyright (C) 2017 Steven Rich
;;
;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA
;;
;;-------------------------------------------------------------------

;; Author: Steven Rich <srichy@mac.com>
;; Created: 01 February 2017
;; Version: 0.1 (2017-02-01)
;; Keywords: keyboard motion

;;; Commentary:
;; (I used key-chord.el as a template for this file)

;; ########   Compatibility   ########################################
;;
;; Developed on Emacs-24.3
;; Others unknown

;; ########   Quick start   ########################################
;;
;; Add to your ~/.emacs
;;
;;	(require 'vimotion)
;;      (vimotion-enable t)
;;      (global-set-key (kbd "C-^") 'vimotion-activate)
;;

;; ########   Description   ########################################
;;
;; vimotion is a essentially a way to transiently "take over" key mapping
;; (by invoking `vimotion-activate') to provide vi-style motion key
;; mappings until any key which is not handled by vimotion is pressed.
;; Once that is done, the previous key mappings are restored and normal
;; Emacs behavior ensues.
;;
;; For example, normal vi 'h', 'j', 'k', and 'l' will allow for character-
;; by-character motion and will remain in vimotion mode.  Any prefix keys
;; (like C-x or C-c) will exit vimotion and pass that key into normal key
;; handling (i.e., it won't be lost).

;;; Code:

;; Internal vars
(defvar vimotion-is-active nil)

(defvar vimotion-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "h") 'backward-char)
    (define-key map (kbd "j") 'next-line)
    (define-key map (kbd "k") 'previous-line)
    (define-key map (kbd "l") 'forward-char)
    (define-key map (kbd "e") (lambda()
                                (interactive)
                                (forward-word)
                                (backward-char)
                                ))
    (define-key map (kbd "w") (lambda ()
                                 (interactive)
                                 (forward-word)
                                 (forward-char)
                                 ))
    (define-key map (kbd "b") 'backward-word)
    (define-key map (kbd "$") 'move-end-of-line)
    (define-key map (kbd "^") 'back-to-indentation)
    (define-key map (kbd "0") 'move-beginning-of-line)
    (define-key map (kbd "C-f") 'scroll-up-command)
    (define-key map (kbd "C-b") 'scroll-down-command)
    (define-key map (kbd "C-u") 'scroll-down-command)
    (define-key map (kbd "C-d") 'scroll-up-command)
    (define-key map (kbd ">") 'scroll-up-line)
    (define-key map (kbd "<") 'scroll-down-line)
    (define-key map (kbd "{") 'backward-paragraph)
    (define-key map (kbd "}") 'forward-paragraph)
    (define-key map (kbd "(") 'backward-sentence)
    (define-key map (kbd ")") 'forward-sentence)
    map))

;;;###autoload
(defun vimotion-enable (arg)
  "Enable toggling vimotion"
  (interactive "P")
  (add-to-list 'minor-mode-alist
               '(vimotion-is-active " !VM!"))
  )

(defun vimotion-end ()
  "Exit vimotion mapping"
  (setq vimotion-is-active nil)
  )

;;;###autoload
(defun vimotion-activate ()
  "Turn on vimotion."
  (interactive)
  (setq vimotion-is-active t)
  (set-transient-map vimotion-keymap t 'vimotion-end)
  )

(provide 'vimotion)

;;; vimotion.el ends here
