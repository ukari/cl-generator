(in-package :cl-user)
(defpackage cl-generator-test
  (:use cl
        lisp-unit
        cl-generator
        cl-generator-util)
  (:export run))

(in-package :cl-generator-test)

(defun run ()
  (setq lisp-unit:*PRINT-ERRORS* t)
  (setq lisp-unit:*PRINT-FAILURES* t)
  (run-tests :all :cl-generator-test))
