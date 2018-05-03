(in-package :cl-user)

(defpackage cl-generator
  (:nicknames generator)
  (:use cl)
  (:export #:lambda*
	   #:defun*
	   #:defmacro*
	   #:yield))
