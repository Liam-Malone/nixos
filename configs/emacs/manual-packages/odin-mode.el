;;; odin-mode.el --- A major mode for Odin                 -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Graham Marlow

;; Author: Graham Marlow
;; Keywords: languages
;; Url: https://git.sr.ht/~mgmarlow/odin-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A major mode for the Odin programming language.

;;; Code:

(require 'js) ; For indentation
(require 'project) ; For build/compile commands

(defgroup odin nil
  "Major mode for the Odin programming language."
  :link '(url-link "https://odin-lang.org")
  :group 'languages)

(defconst odin-keywords
  '("import" "foreign" "package"
    "where" "when" "if" "else" "for" "switch" "in" "do" "case"
    "break" "continue" "fallthrough" "defer" "return" "proc"
    "struct" "union" "enum" "bit_field" "bit_set" "map" "dynamic"
    "auto_cast" "cast" "transmute" "distinct" "opaque"
    "using" "inline" "no_inline"
    "size_of" "align_of" "offset_of" "type_of"
    "context"))

(defconst odin-builtins
  '("len" "cap"
    "typeid_of" "type_info_of"
    "swizzle" "complex" "real" "imag" "quaternion" "conj"
    "jmag" "kmag"
    "min" "max" "abs" "clamp"
    "expand_to_tuple"

    "init_global_temporary_allocator"
    "copy" "pop" "unordered_remove" "ordered_remove" "clear" "reserve"
    "resize" "new" "new_clone" "free" "free_all" "delete" "make"
    "clear_map" "reserve_map" "delete_key" "append_elem" "append_elems"
    "append" "append_string" "clear_dynamic_array" "reserve_dynamic_array"
    "resize_dynamic_array" "incl_elem" "incl_elems" "incl_bit_set"
    "excl_elem" "excl_elems" "excl_bit_set" "incl" "excl" "card"
    "assert" "panic" "unimplemented" "unreachable"))

(defconst odin-constants
  '("nil" "true" "false"))

(defconst odin-typenames
  '("bool" "b8" "b16" "b32" "b64"

    "int"  "i8" "i16" "i32" "i64"
    "i16le" "i32le" "i64le"
    "i16be" "i32be" "i64be"
    "i128" "u128"
    "i128le" "u128le"
    "i128be" "u128be"

    "uint" "u8" "u16" "u32" "u64"
    "u16le" "u32le" "u64le"
    "u16be" "u32be" "u64be"

    "f32" "f64"
    "complex64" "complex128"

    "quaternion128" "quaternion256"

    "rune"
    "string" "cstring"

    "uintptr" "rawptr"
    "typeid" "any"
    "byte"))

(defvar odin-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; Operators
    (dolist (i '(?: ?+ ?- ?* ?= ?< ?> ?& ?| ?^ ?! ??))
      (modify-syntax-entry i "." table))

    ;; Strings
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\\ "\\" table)

    ;; Comments
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23n" table)
    (modify-syntax-entry ?\n "> b" table)
    (modify-syntax-entry ?\^m "> b" table)

    table))

(defvar odin-font-lock-keywords
  `(
    ;; Keywords
    (,(regexp-opt odin-keywords 'symbols) . font-lock-keyword-face)

    ;; Types
    (,(regexp-opt odin-typenames 'symbols) . font-lock-type-face)

    ;; Attributes
    ("^ *@[a-zA-Z]+" . font-lock-preprocessor-face)

    ;; Builtins
    (,(regexp-opt odin-builtins 'symbols) . font-lock-builtin-face)

    ;; Constants
    (,(regexp-opt odin-constants 'symbols) . font-lock-constant-face)))

;;;###autoload
(define-derived-mode odin-mode
  prog-mode "Odin"
  "Major mode for the Odin programming language."
  :group 'odin
  :syntax-table odin-mode-syntax-table

  (setq-local font-lock-defaults
              '(odin-font-lock-keywords))

  (setq-local parse-sexp-ignore-comments t)
  (setq-local comment-start-skip "\\(//+\\|/\\*+\\)\\s *")
  (setq-local comment-start "/*")
  (setq-local comment-end "*/")

  (setq-local indent-line-function #'js-indent-line)

  (setq-local electric-indent-chars
              (append "{}():;," electric-indent-chars)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-mode))

(defcustom odin-bin "odin"
  "Path to odin executable."
  :type 'string
  :group 'odin-mode)

(defun odin--project-cmd (format-string)
  "Execute odin on current project.

FORMAT-STRING is the command passed to the odin binary.  The
current project directory is always passed as the first argument."
  (unless (project-current)
    (error "No project found"))
  (let ((default-directory (project-root (project-current))))
    (compile (apply #'format
                    (concat "%s " format-string " %s")
                    (list odin-bin default-directory)))))

(defun odin-build-project ()
  "Build curent project using `odin build`."
  (interactive)
  (odin--project-cmd "build"))

(defun odin-run-project ()
  "Run current project using `odin run`."
  (interactive)
  (odin--project-cmd "run"))

(defun odin-check-project ()
  "Check current project using `odin check`."
  (interactive)
  (odin--project-cmd "check"))

(defun odin-test-project ()
  "Run procedures marked by the attribute @(test) using `odin test`."
  (interactive)
  (odin--project-cmd "test"))

(provide 'odin-mode)

;;; odin-mode.el ends here
